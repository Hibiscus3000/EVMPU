#include <iostream>
#include <libusb.h>
#include <stdio.h>

using namespace std;

void printSerialNumberAndProductDescription(libusb_device *dev, libusb_device_descriptor desc, FILE * out);
void printdev(libusb_device *dev, FILE * out);

int main()
{
    FILE * out = fopen("devices_description.txt","w");
    if (!out)
        return 1;
    libusb_device **devs; // указатель на указатель на устройство,
    // используется для получения списка устройств
    libusb_context *ctx = NULL; // контекст сессии libusb
    int r; // для возвращаемых значений
    ssize_t cnt; // число найденных USB-устройств
    ssize_t i; // индексная переменная цикла перебора всех устройств
    // инициализировать библиотеку libusb, открыть сессию работы с libusb
    r = libusb_init(&ctx);
    if(r < 0)
    {
        fprintf(out,"Ошибка: инициализация не выполнена, код: %d.\n", r);
        return 1;
    }
    // задать уровень подробности отладочных сообщений
    libusb_set_debug(ctx, 3);
    // получить список всех найденных USB- устройств
    cnt = libusb_get_device_list(ctx, &devs);
    if(cnt < 0)
    {
        fprintf(out, "Ошибка: список USB устройств не получен, код: %d\n", r);
        return 1;
    }
    for(i = 0; i < cnt; i++)
    { // цикл перебора всех устройств
        printdev(devs[i],out); // печать параметров устройства
    }
    // освободить память, выделенную функцией получения списка устройств
    libusb_free_device_list(devs, 1);
    libusb_exit(ctx); // завершить работу с библиотекой libusb,
    // закрыть сессию работы с libusb
    return 0;
}

void printSerialNumberAndProductDescription(libusb_device *dev, libusb_device_descriptor desc, FILE * out)
{
    int r;
    unsigned char * serialNumber = new unsigned char [200];
    libusb_device_handle * devh;
    r = libusb_open(dev,&devh);
    if (r)
        fprintf(out,"\tОшибка: не удалось получить device_handle\n");
    r = libusb_get_string_descriptor_ascii(devh,desc.iSerialNumber,serialNumber,200);
    if (r < 0)
        fprintf(out, "\tОшибка: серийный номер устройства не получен, код: %d\n",r);
    else
        fprintf(out,"\tСерийный номер USB устройства: %s\n", serialNumber);
    delete(serialNumber);
    unsigned char * product = new unsigned char [200];
    r = libusb_get_string_descriptor_ascii(devh,desc.iProduct,product,200);
    if (r < 0)
        fprintf(out, "\tОшибка: описание продукта не получено, код: %d\n",r);
    else
        fprintf(out,"\tПродукт: %s\n", product);
    delete(product);
    libusb_close(devh);
}

void printdev(libusb_device *dev, FILE * out)
{
    libusb_device_descriptor desc; // дескриптор устройства
    libusb_config_descriptor *config; // дескриптор конфигурации объекта
    const libusb_interface *inter; // набор различных установок для определенного USB интерфейса
    const libusb_interface_descriptor *interdesc; // дескриптор интерфейса
    const libusb_endpoint_descriptor *epdesc;
    int i,j,k,r = libusb_get_device_descriptor(dev, &desc);
    fprintf(out,"===============================================================================\n\n");
    if (r < 0)
    {
        fprintf(out, "\tОшибка: дескриптор устройства не получен, код: %d\n",r);
        return;
    }
    // получить конфигурацию устройства
    libusb_get_config_descriptor(dev, 0, &config);
    fprintf(out,"\tколичество конфигураций: %.2d\n\tкласс устройства: %.2d\n\tидентификатор производителя: %.4d\n\tидентификатор изделия: %.4d\n\tколичество интерфейсов: %.3d\n",
    (int)desc.bNumConfigurations,
    (int)desc.bDeviceClass,
    desc.idVendor,
    desc.idProduct,
    (int)config->bNumInterfaces
    );
    printSerialNumberAndProductDescription(dev,desc,out);
    for(i=0; i<(int)config->bNumInterfaces; i++) //цикл перебора всех интерфейсов, поддерживаемых данной конфигурацией
    {
        inter = &config->interface[i];
        fprintf(out,"\t%d. количество различных установок интерфейса: %.2d\n",i + 1, inter->num_altsetting);
        for(j=0; j<inter->num_altsetting; j++)
        {
            interdesc = &inter->altsetting[j];
            fprintf(out,"\t\t%d) номер интерфейса: %.2d\n\t\tколичество ""конечных точек"": %.2d\n", j + 1,
            (int)interdesc->bInterfaceNumber,
            (int)interdesc->bNumEndpoints
        );
            for(k=0; k<(int)interdesc->bNumEndpoints; k++)
            {
                epdesc = &interdesc->endpoint[k];
                fprintf(out,"\t\t\t%d. тип дескриптора: %.2d\n\t\t\tадрес ""конечной точки"": %.9d\n",k + 1,
                (int)epdesc->bDescriptorType,
                (int)epdesc->bEndpointAddress
                );
            }
        }
    }
    fprintf(out,"\n===============================================================================\n");
    libusb_free_config_descriptor(config);
}
