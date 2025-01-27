%% Condicionamento dos dados
clear all;
load('data.mat');
load('test.mat');

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

%% Vetor aleat�rio da elm
R = normrnd(0,0.2,785,500);

H1 = treino*R;
H2 = validacao*R;

%% tgh

H = tanh(H1);
H_val = tanh(H2);

%% Regressao linear
identidade = eye(500);

% i = 10;
for i = 1:size(lambda, 2)
    reg = H' * H + lambda(i)*identidade;
    w = inv(reg) * H' * treino_saida_original;
    
    y_classificacao = (H_val * w);
    [~,class_out(:,1)] = (max(y_classificacao,[],2));
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
    
%     y = (validacao * w - validacao_saida_original);
%     y_erro = sum(y.^2,1)/num_amostras_treino;
%     y_erro_lambda(i) = sum(y_erro.^2)/10;
end

%%
figure()
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
    reg = H' * H + lambda(i)*identidade;
    w = inv(reg) * H' * treino_saida_original;
    
    y_classificacao = (H_val * w);
    [~,class_out(:,1)] = (max(y_classificacao,[],2));
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


%% +++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++


final = ones(60000,785);
final(:,2:785) = X;

finalt = ones(10000,785);
finalt(:,2:785) = Xt;

H1 = final*R;
% tgh
H = tanh(H1);

H_t = finalt*R;
% tgh
H_2 = tanh(H_t);

lambda = 60;

    reg = H' * H + lambda*identidade;
    w = inv(reg) * H' * S;
    
    dlmwrite('n178499_q3.txt', w)
%%

H_t = finalt*R;
% tgh
H_2 = tanh(H_t);

    y_classificacao = (H_2 * w);
    [~,class_out1(:,1)] = (max(y_classificacao,[],2));
    [~,class_out1(:,2)] = (max(St,[],2));
    
    erro_quadratico_medio = immse(y_classificacao, St);
    class_out1(:,3) = class_out1(:,1) - class_out1(:,2);
    %%
    j = 0;
    for k = 1:size(class_out,1)
        if class_out1(k,3) == 0
            j = j + 1;
        end
    end
    %%
    plot_x = lambda;
    plot_y_erro = erro_quadratico_medio;
    plot_y_class = j / 10000;
    
    %%
    