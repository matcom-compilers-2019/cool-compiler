## Instrucciones para usar el tester

En la carpeta brindamos un archivo `test.sh`, que usted podra ejecutar para ver compilar una serie de programas de `cool` y obtener su resultado en la carpeta `Output`. Para hacer uso completo de las funcionalidades de nuestro sistema de prueba, continue leyendo.


El probador puede ejecutarse a traves del comando

``` py
python3 test.py -p <file>
```
 De esta forma se generara un archivo `.s` del mismo nombre en la carpate `Output`, listo para ejecutar en un interprete de MIPS. 

 Para compilar varios archivos, es posible usar la opcion

``` py
python3 test.py -r <folder>
```

Donde recursivamente se compilaran todos los archivos `.cl` que se encuentran en la carpeta y su salida se incluira en la carpeta `Output`