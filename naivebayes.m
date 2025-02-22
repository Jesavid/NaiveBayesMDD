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


