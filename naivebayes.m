% Programa para predecir un diagnóstico y clasificar en base a caso previamente
% observados

% Crear una máscara para los casos malignos y benignos -------------------------
mapMaligno = Train(:,11)==4;
mapBenigno = Train(:,11)==2;

% Usar la máscara para obtener sets con solo los casos malignos y benignos------
Malignos=Train((mapMaligno),:);
Benignos=Train((mapBenigno),:);

% Contar malignos y benignos
numMalignos=size(Malignos,1);
numBenignos=size(Benignos,1);

% Definir función de probabilidad
function [Prob] = Probabilidad(Casos,columna,valorColumna)
   num=size(Casos,1);
   Mapa=Casos(:,columna)==valorColumna;
   numCritero=sum(Mapa);
   Prob=numCriterio/num;
 end

% Calcular probabilidad de cada clase
totalTrain=size(Train,1);
probabilidadMaligno=numMalignos/totalTrain;
probabilidadBenigno=1-probabilidadMaligno;
