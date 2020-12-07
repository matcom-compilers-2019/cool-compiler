# Documentación

**Nombre** | **Github**
--|--|--
José Jorge Rodríguez Salgado | [@JoseJorgeXL](https://github.com/JoseJorgeXL)
Christian Rodríguez Díaz  | [@WrathXL](https://github.com/WrathXL)
Hector Adrián Castellano Loaces | [@hectoradrian961030 ](https://github.com/hectoradrian961030)
Alberto González Rosales |  [@albexl](https://github.com/albexl)

## Requisitos y uso del presente compilador: 


La presente implementación de un compilador del lenguaje Cool fue echa en Python3. Para compilar el código Cool contenido en un archivo de 
entrada y obtener el correspondiente código MIPS en otro archivo de salida se debe ejecutar el script `coolc.sh` que se encuentra en
el directorio `src` pasando como parámetros el path completo de los archivos de entrada, que generara un archivo `.s` con el mismo nombre listo para ejecutar. A continuación un ejemplo:

    ./coolc.sh <input-path> 

En el ejemplo anterior se supone que el comando está escrito en una terminal abierta en el directorio `src`, el valor entre angulares es el path del archivo de entrada.

Para lograr ejecutar el proyecto es necesario hacer `make`, lo cual posibilitara la instalacion de los paquetes de `python3` necesarios para la ejecucion del proyecto

Si se desea ver el compilador en accion dentro de la carpeta `test` se han incluido una serie de pruebas, con un respectivo archivo `Readme.md` para explicar su uso

No existe ningún otro requisito para utilizar el presente compilador que no sean los expuestos anteriormente.
