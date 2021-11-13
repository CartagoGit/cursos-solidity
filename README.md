# Carpetas con los archivos de los cursos de Solidity

Los commits iran señalados segun el curso, las seccion y la clase (omitiendo fallos en alguna enumeracion por no correccion)

## Curso-Seccion-cClase

### Ejemplo

02-04-c30
Lo que indicaría, que el comit es del curso 2, en la seccion 4, y la clase 30

## Comando para acceder desde el localhost a remix en el IDE de chrome

remixd -s V:\_RelaxingCup\cursos\Solidity\ --remix-ide https://remix.ethereum.org

## Teniendo la extension general del prettier y la extension de Juan Blanco de Solidity instaladas en el vscode

### Para añadir el plugin prettier para solidity

npm install --save-dev prettier prettier-plugin-solidity

### En el settings.json global ( o en la configuracion del prettier en el proyecto) 

    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "prettier.printWidth": 550,
    "prettier.tabWidth": 6,
    "prettier.proseWrap": "preserve",
    "prettier.requirePragma": true,
    "prettier.insertPragma": true,
    "prettier.semi": true,
    "prettier.bracketSpacing": true,
    "prettier.singleQuote": false,
    "prettier.useTabs": true,
    "prettier.arrowParens": "always",
    "[solidity]": {
            "prettier": "prettier",
            "editor.defaultFormatter": "esbenp.prettier-vscode",
            "compileUsingRemoteVersion": "latest",
            "enabledAsYouTypeCompilationErrorCheck": true,
            "validationDelay": 1500,
            "linter": "solhint"
      }

