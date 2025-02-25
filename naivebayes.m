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

% Calcular probabilidad de cada clase
totalTrain=size(Train,1);
probabilidadMaligno=numMalignos/totalTrain;
probabilidadBenigno=1-probabilidadMaligno;

%Generar un array con lso valores únicos de toda la tabla
%uniqueMaligno=unique(Malignos(:,2:10));
%uniqueBenigno=unique(Benignos(:,2:10));

% Contar instancias para cada caso
% La función recibe la matriz con los valores de la clase, los atributos
% (features) y los valores (values) que pueden tomar los atributos (1:10)
function [featuresCount] = FeautersCounting(Matriz)
    % Crear una matriz en 0 para guardar el conteo de los atributos
    featuresCount = zeros(9,10);

    % Recorrer cada columna de la matriz
    for i=1:length(Matriz)
      % Obtener todas las filas para cada columna i
      filas=Matriz(i,:);

      % Recorrer cada fila
      for j=2:10
        % Obtener el valor de cada celda
        celda=filas(j);
        featuresCount(j-1,celda)=featuresCount(j-1,celda)+1;
      endfor
    endfor
    featuresCount;
endfunction

% Obtener matrices con el conteo de atributos
malignosFeatures=FeautersCounting(Malignos);
benignosFeatures=FeautersCounting(Benignos);

% Quitar ceros
malignosFeaturesNoZeros=malignosFeatures+1;
benignosFeaturesNoZeros=benignosFeatures+1;

% Normalización
probabilidadAtributoMaligno=malignosFeaturesNoZeros/(length(Malignos+10));
probabilidadAtributoBenigno=benignosFeaturesNoZeros/(length(Benignos+10));

% Evaluar la probabilidad de la matriz Test

% Definir función de probabilidad. Recibe los atributos a evaluar y la matriz
% con las probabilidad para la clase
function [probabilidadAtributo] = Probabilidad(features,MatrizProbabilidad)
  probabilidadAtributo=1;

  for i=2:10
    probabilidadAtributo=probabilidadAtributo*MatrizProbabilidad(i-1,features(i));
  endfor
endfunction

% Predecir casos
predictTest=Test;
prediccionMatriz=zeros(length(predictTest),1);
for i=1:length(predictTest)
  prediction=1;
  testCase=predictTest(i,:);
  probabilidadDeSerBenigno=Probabilidad(testCase,probabilidadAtributoBenigno)*probabilidadBenigno;
  probabilidadDeSerMaligno=Probabilidad(testCase,probabilidadAtributoMaligno)*probabilidadMaligno;

  if probabilidadDeSerBenigno>probabilidadDeSerMaligno
    prediction=2;
  else
    prediction=4;
  endif

  prediccionMatriz(i,1)=prediction;
endfor

% Evaluar el desempeño del modelo

% Definir función para clasificar los resultados

function [evaluacionMatriz]=evaluarPrediccion(matrizResultados, claseEvaluada,predictTest)
  evaluacionMatriz={'True Positive',0;'True Negative',0;'False Positive',0;'False Negative',0};

  for i=1:length(predictTest)
    % Primero se evalúa si la predicción es igual a la etiqueta del Test para
    % obtener las predicciones True
    if matrizResultados(i,1)==predictTest(i,11);
      % Después se evalúa si la predicción corresponde a la clase para saber si es
      % TP o TN
      if matrizResultados(i,1)==claseEvaluada
        evaluacionMatriz{1,2} = evaluacionMatriz{1,2} + 1;
      else
        evaluacionMatriz{2,2} = evaluacionMatriz{2,2} + 1;
      endif
    endif
    % Primero obtenemos las predicciones False
    if matrizResultados(i,1)!=predictTest(i,11);
      % Se evalua para saber si es FP o FN
      if matrizResultados(i,1)==claseEvaluada
        evaluacionMatriz{3,2} = evaluacionMatriz{3,2} + 1;
      else
        evaluacionMatriz{4,2} = evaluacionMatriz{4,2} + 1;
      endif
    endif
  endfor
endfunction

% Calcular métricas de evaluación
% Evaluación para la clase 4
matrizMetricasMaligno = evaluarPrediccion(prediccionMatriz,4,predictTest);

% Accuracy = True Postivie/(True Positive+False Positive+False Negative)
accuracyMaligno=matrizMetricasMaligno{1,2}/(matrizMetricasMaligno{1,2}+matrizMetricasMaligno{3,2}+matrizMetricasMaligno{4,2});

% precision=True Positive/(True Positive+False Positive)
precisionMaligno=matrizMetricasMaligno{1,2}/(matrizMetricasMaligno{1,2}+matrizMetricasMaligno{3,2});

% recall=True Positive/(True Positive+False Negative)
recallMalingo=matrizMetricasMaligno{1,2}/(matrizMetricasMaligno{1,2}+matrizMetricasMaligno{4,2});

% fScore=(2*precision*recall)/(precision*recall)
fScoreMaligno=(2*recallMalingo*recallMalingo)/(recallMalingo+recallMalingo)

% Evaluación para la clases 2
% Calcular métricas de evaluación
matrizMetricasBenigno = evaluarPrediccion(prediccionMatriz,2,predictTest);

% Accuracy = True Postivie/(True Positive+False Positive+False Negative)
accuracyBenigno=matrizMetricasBenigno{1,2}/(matrizMetricasBenigno{1,2}+matrizMetricasBenigno{3,2}+matrizMetricasBenigno{4,2});

% precision=True Positive/(True Positive+False Positive)
precisionBenigno=matrizMetricasBenigno{1,2}/(matrizMetricasBenigno{1,2}+matrizMetricasBenigno{3,2});

% recall=True Positive/(True Positive+False Negative)
recallBenigno=matrizMetricasBenigno{1,2}/(matrizMetricasBenigno{1,2}+matrizMetricasBenigno{4,2});

% fScore=(2*precision*recall)/(precision*recall)
fScoreBenigno=(2*precisionBenigno*recallBenigno)/(precisionBenigno+recallBenigno)

% Extraer las métricas y valores de la matriz para la clase Maligno
metricas = matrizMetricasMaligno(:, 1);  % Nombres de las métricas
valores = cell2mat(matrizMetricasMaligno(:, 2));  % Valores de las métricas convertidos a números

% Evaluación del model general
evaluacionMatrizGeneral={'Accuracy',0;'Precision',0;'Recall',0;'Fscore',0};
evaluacionMatrizGeneral{1,2}=(matrizMetricasBenigno{1,2}+matrizMetricasBenigno{2,2})/length(predictTest);
evaluacionMatrizGeneral{2,2}=(precisionBenigno+precisionMaligno)/2;
evaluacionMatrizGeneral{3,2}=(recallBenigno+recallMalingo)/2;
evaluacionMatrizGeneral{4,2}=(fScoreBenigno+fScoreMaligno)/2;

% Crear una nueva figura
figure;

% Primer subgráfico para la clase Maligno
subplot(1, 2, 1);  % Crear una figura con 1 fila y 2 columnas, y seleccionar la primera
bar(valores);
xticks(1:length(metricas));
xticklabels(metricas);
xlabel('Métricas');
ylabel('Valor');
title('Matriz de confusión para la clase Maligno');
grid on;

% Extraer las métricas y valores de la matriz para la clase Benigno
metricas = matrizMetricasBenigno(:, 1);
valores = cell2mat(matrizMetricasBenigno(:, 2));

% Segundo subgráfico para la clase Benigno
subplot(1, 2, 2);  % Seleccionar la segunda posición en la figura
bar(valores);
xticks(1:length(metricas));
xticklabels(metricas);
xlabel('Métricas');
ylabel('Valor');
title('Matriz de confusión para la clase Benigno');
grid on;

% Crear diagramas para las métricas
%figure;
%suplot(1,2,1);
%bar(porcentaje);
%xticks('Maligno','Benigno')
%xtickslables
