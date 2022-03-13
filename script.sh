#!/bin/bash

if [ ! -d "venv" ]
then
    echo "Criando o ambiente virtual..."
    python3.7 -m venv venv
fi

ROOT=$PWD

for path in lambdas/*/
do
    if [[ -d "$path" ]] 
    then
        echo "pasta root $path"
        FUNCTION_NAME=$(basename $path)
        BUILD_PACKEGE_NAME="$FUNCTION_NAME.zip"
        if [[ -f $path/requirements.txt ]]
        then
            
            echo "instalando dependencias da lambda $FUNCTION_NAME"
            pip install -r lambdas/$FUNCTION_NAME/requirements.txt --target lambdas/$FUNCTION_NAME/packages/ --find-links ./packages
            
            cd lambdas/$FUNCTION_NAME
            echo "Building $FUNCTION_NAME..."
            
            cd packages
            zip -r ../$BUILD_PACKEGE_NAME .            
            cd ..
            rm -rf packages
            zip -g $BUILD_PACKEGE_NAME *.py src/*
        else
            cd lambdas/$FUNCTION_NAME
            echo "Building $FUNCTION_NAME..."
            zip -r $BUILD_PACKEGE_NAME . -i *.py src/*
        fi
        
        cd $ROOT
    else
        continue
    fi
    
done