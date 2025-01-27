%% Condicionamento dos dados
clear all;
load('data.mat');

rand_seed = 178499;
num_pixels = 784;
num_classes = 10;
num_amostras_max = 60000;
num_amostras_treino = 40000;
num_amostras_validacao = num_amostras_max - num_amostras_treino;
lambda = 2.^(-10:2:12);

rng(rand_seed);
hold_out_div = randi(num_amostras_max);

idx_inicio_treino = hold_out_div;
idx_fim_treino = mod(hold_out_div + num_amostras_treino, num_amostras_max);

treino = ones(num_amostras_treino, num_pixels + 1);
treino_saida_original = ones(num_amostras_treino, num_classes);
for i = 1:num_amostras_treino
    idx = mod(i + idx_inicio_treino, num_amostras_max) + 1;
    treino(i,2:num_pixels + 1) = X(idx,:);
    treino_saida_original(i,:) = S(idx,:);
end

validacao = ones(num_amostras_validacao, num_pixels + 1);
validacao_saida_original = ones(num_amostras_validacao, num_classes);
for i = 1:num_amostras_validacao
    idx = mod(i + idx_fim_treino, num_amostras_max) + 1;
    validacao(i,2:num_pixels + 1) = X(idx,:);
    validacao_saida_original(i,:) = S(idx,:);
end

%% Regressao linear
identidade = eye(num_pixels + 1);

% i = 10;
for i = 1:size(lambda, 2)
    reg = treino' * treino + lambda(i)*identidade;
    w = inv(reg) * treino' * treino_saida_original;
    
    y_classificacao = (validacao * w);%).^2;
    [~,class_out(:,1)] = (max(abs(y_classificacao),[],2));
    [~,class_out(:,2)] = (max(validacao_saida_original,[],2));
    
    erro_quadratico_medio = immse(y_classificacao, validacao_saida_original);
    class_out(:,3) = class_out(:,1) - class_out(:,2);
    
    j = 0;
    for k = 1:size(class_out,1)
        if class_out(k,3) == 0
            j = j + 1;
        end
    end
    
    plot_x(i) = lambda(i);
    plot_y_erro(i) = erro_quadratico_medio;
    plot_y_class(i) = j / num_amostras_validacao;

end
%%
a(1) = subplot(1,2,1);
semilogx(plot_x, plot_y_erro)
title(a(1),'Erro Quadr�tico M�dio em fun��o de \lambda')
xlabel(a(1),'\lambda')
ylabel(a(1),'Erro Quadr�tico M�dio')
grid

a(2)= subplot(1,2,2);
semilogx(plot_x, plot_y_class)
title(a(2),'Acerto de classifica��o fun��o de \lambda')
xlabel(a(2),'\lambda')
ylabel(a(2),'Acerto de Classifica��o')
grid

%% Busca refinada
lambda = linspace(10,1000, 20);

for i = 1:size(lambda, 2)
    reg = treino' * treino + lambda(i)*identidade;
    w = inv(reg) * treino' * treino_saida_original;
    
    y_classificacao = (validacao * w);%).^2;
    [~,class_out(:,1)] = (max(abs(y_classificacao),[],2));
    [~,class_out(:,2)] = (max(validacao_saida_original,[],2));
    
    erro_quadratico_medio = immse(y_classificacao, validacao_saida_original);
    class_out(:,3) = class_out(:,1) - class_out(:,2);
    
    j = 0;
    for k = 1:size(class_out,1)
        if class_out(k,3) == 0
            j = j + 1;
        end
    end
    
    plot_x(i) = lambda(i);
    plot_y_erro(i) = erro_quadratico_medio;
    plot_y_class(i) = j / num_amostras_validacao;

end
%%
figure()
title('Busca refinada')
a(1) = subplot(1,2,1);
semilogx(plot_x, plot_y_erro)
title(a(1),'Erro Quadr�tico M�dio em fun��o de \lambda')
xlabel(a(1),'\lambda')
ylabel(a(1),'Erro Quadr�tico M�dio')
grid

a(2)= subplot(1,2,2);
semilogx(plot_x, plot_y_class)
title(a(2),'Acerto de classifica��o fun��o de \lambda')
xlabel(a(2),'\lambda')
ylabel(a(2),'Acerto de Classifica��o')
grid

%% Validacao


%% Visualizacao

% reg = treino' * treino + lambda(i)*identidade;
% reg = treino' * treino + 700*identidade;
% w = inv(reg) * treino' * treino_saida_original;

final = ones(60000,785);
final(:,2:785) = X;

finalt = ones(10000,785);
finalt(:,2:785) = Xt;

lambda = 700;

reg = final' * final + lambda*identidade;
w = inv(reg) * final' * S;

    y_classificacao = (finalt * w);
    
    [~,class_out3(:,1)] = (max(y_classificacao,[],2));
    [~,class_out3(:,2)] = (max(St,[],2));
    
    erro_quadratico_medio = immse(y_classificacao, St);
    class_out(:,3) = class_out(:,1) - class_out(:,2);
   
    j = 0;
    for k = 1:size(class_out,1)
        if class_out(k,3) == 0
            j = j + 1;
        end
    end
    
    plot_x(1) = lambda(1);
    plot_y_erro(i) = erro_quadratico_medio;
    plot_y_class = j / num_amostras_validacao;
    %%
    dlmwrite('n178499_q2.txt', w)
    
    figure()
title('Busca refinada')
a(1) = subplot(1,2,1);
semilogx(plot_x, plot_y_erro)
title(a(1),'Erro Quadr�tico M�dio em fun��o de \lambda')
xlabel(a(1),'\lambda')
ylabel(a(1),'Erro Quadr�tico M�dio')
grid

a(2)= subplot(1,2,2);
semilogx(plot_x, plot_y_class)
title(a(2),'Acerto de classifica��o fun��o de \lambda')
xlabel(a(2),'\lambda')
ylabel(a(2),'Acerto de Classifica��o')
grid

%%
% dlmwrite('teste.txt',w)
figure()
[nl,nc] = size(X);
% [nl,nc] = size(Xt);
for ind = 1:nl
    k = 1;
    for i=1:28
        for j=28:-1:1
            v(i,j) = w(k,ind);  
%             v(i,j) = X(ind,k);
%             v(i,j) = Xt(ind,k);
            k = k+1;
        end
    end
    pcolor([1:28],[1:28],v');
    colorbar;
    disp('Sa�da desejada')
    disp(S(ind,:));
%     disp(St(ind,:));
    disp('Digite ENTER para visualizar o pr�ximo d�gito ou CTRL-C para interromper a execu��o')
    pause;
end

