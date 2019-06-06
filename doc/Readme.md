# Documentación

**Nombre** | **Grupo** | **Github**
--|--|--
José Jorge Rodríguez Salgado | C411 | [@JoseJorgeXL](https://github.com/JoseJorgeXL)
Christian Rodríguez Díaz | C411 | [@github_user](https://github.com/<user>)
Hector Adrián Castellano Loaces | C411 | [@github_user](https://github.com/<user>)
Alberto González Rosales | C411 | [@github_user](https://github.com/<user>)

## Requisitos y uso del presente compilador:

La presente implementación de un compilador del lenguaje Cool fue echa en Python3. Para compilar el código Cool contenido en un archivo de 
entrada y obtener el correspondiente código MIPS en otro archivo de salida se debe ejecutar el script de Python `cool.py` que se encuentra en
el directorio `src` pasando como parámetros el path completo de los archivos de entrada y de salida respectivamente. A continuación un ejemplo:

    python ./cool.py <input-path> <output-path>

En el ejemplo anterior se supone que el comando está escrito en una terminal abierta en el directorio `src`, que `python` se refiere al 
intérprete de Python3 y los valores entre angulares son el path de los archivos de entrada y salida respectivamente.

Para la fase de parsing fue utilizado el generador de parsers Lark, el cual puede ser instalado utilizando el gestor de paquetes pip o puede 
ser descargado de GitHub. A continuación el comando que debe ser escrito para instalar el módulo Lark utilizando el gestor de paquetes pip:
    
    pip install lark-parser

No existe ningún otro requisito para utilizar el presente compilador que no sean los expuestos anteriormente.