clc;
%%
%study study
disp('max, f(x1,x2) = 19 + x1inrange(a)*(sin(x1inrange(a)*3.14)) + (10-x2inrange(a))*(sin(x2inrange(a)*3.14))')
disp(' ')
%%
% menentukan parameter populasi, khusus untuk penentuan jumlah kromosom,
% perlu ada perhitungan lebih lanjut
nindividu = 18;
ngenerasi = 200;
% menentukan jumlah kromosom :
% total digit real: range * 10^3 = 10^4
% menghitung jumlah bit bilangan basis 2 yang diperlukan agar dapat
% menampung sejumlah 10^5 bilangan basis 10
%%
%1.Representasi Chromosome

%ketelitian 
pangkat = 4;
total = 1;
%m1
disp('148.001 <= 2^m1');
formulacari1=(9.8-(-5))* 10^4-1;
m1 = 17.1752;m1d=18;
disp('m1 ='),disp(ceil(m1));

%m2
disp('73.001 <= 2^m2');
formulacari2=(7.3-0)* 10^4-1;
m2 = 73.001;m2d=17;  
disp('m2 = 17');
disp(' ');

panjang_string_chromosome = m1d+m2d 

%nilai sampling parent
pj =de2bi(m1d)
pj =de2bi(m2d)
%%
%2.inisialisasi cromosom (lanjutan)
%sampling popsize = 10
while (total <= 10)
pangkat = pangkat + 1;
total = total + (2 ^ pangkat);
end;
%% 
%3.Reproduksi (yang digunakan metode crossover)
pangkat = pangkat + 1;
% jumlah total kromosom
nkromosom = pangkat * 2;
% menentukan lokasi crossover
lokasi_crossover = floor(rand(1,1) * (nkromosom - 2)) + 1;
% membangkitkan population
individu = floor(rand(nindividu,nkromosom) * 2);
% mencatat fitness yang didapatkan di setiap iterasi
fitness_berjalan = -9999;
fitness_terbaik(1) = fitness_berjalan;
%%
%4.evaluasi
% proses evaluasi genetik berjalan:
for gen = 1 : ngenerasi
% mengkonversi bilangan biner ke bilangan cacah
for a=1:(nindividu)
x1(a)=0;
x2(a)=0;
for (b=1:nkromosom/2)
if individu(a,b) == 1
x1(a) = x1(a) + (2^(b-1));
end;
if individu(a,b+(nkromosom/2)) == 1
x2(a) = x2(a) + (2^(b-1));
end;
end;
end;
% mengkonversi bilangan cacah ke bilangan real dengan range yang telah ditentukan
x1inrange = (-2.0) + ((17.5 / total) * x1);
x2inrange = (3.27) + ((5.48 / total) * x2);
% menghitung nilai fitness seluruh individu
for a=1:nindividu
fitness(a) = 19 + x1inrange(a)*(sin(x1inrange(a)*3.14)) + (10-x2inrange(a))*(sin(x2inrange(a)*3.14));
% mencatat nilai fitness, x1 terbaik, dan x2 terbaik yang
% didapatkan pada setiap iterasi
if fitness_berjalan < fitness(a)
fitness_terbaik(gen) = fitness(a);
fitness_berjalan = fitness(a);
x1terbaik = x1inrange(a);
x2terbaik = x2inrange(a);
else
fitness_terbaik(gen) = fitness_berjalan;
end;
end;
% mencatat nilai rata-rata, maksimum, dan minimum fitness di setiap
% iterasi
rata_rata_fitness(gen) = mean(fitness);
max_fitness(gen) = max(fitness);
min_fitness(gen) = min(fitness);
% menghitung total fitness
total_fitness = sum(fitness);
% menghitung probabilitas fitness setiap individu
for a=1:nindividu
probabilitas_fitness(a) = fitness(a) / total_fitness;
end;
% menghitung kumulatif probabilitas fitness di roulete wheel
kumulatif_fitness = cumsum(probabilitas_fitness);
%%
%5.evaluasi
% menentukan lokasi sample di roulete wheel
roulete = rand(1,nindividu);
% memilih parent
for a = 1:nindividu
for b = 1:nindividu
if roulete(a) <= kumulatif_fitness(b)
parent(a) = b;
end;
end;
end;
% melakukan crossover
for a = 1 : (nindividu/2)
indeks = ((a - 1) * 2);
for b = 1 : lokasi_crossover
anak(indeks+1,b) = individu(parent(indeks+1),b);
anak(indeks+2,b) = individu(parent(indeks+2),b);
end;
for b = lokasi_crossover+1 : nkromosom
anak(indeks+1,b) = individu(parent(indeks+2),b);
anak(indeks+2,b) = individu(parent(indeks+1),b);
end;
end;
% menentukan tingkat mutasi
probabilitas_mutasi = 0.025;
% menghitung kromosom yang terkena mutasi
jumlah_kromosom_mutasi = round(probabilitas_mutasi * (nindividu * nkromosom));
% menentukan lokasi kromosom yang terkena mutasi
mutasi = ceil(rand(1,jumlah_kromosom_mutasi) * (nindividu * nkromosom));
% menerapkan mutasi pada beberapa kromosom
for a = 1:jumlah_kromosom_mutasi
individu_ke = ceil(mutasi(a) / nkromosom);
kromosom_ke = mod(mutasi(a),nkromosom);
if kromosom_ke == 0
kromosom_ke = nkromosom;
end;
if anak(individu_ke,kromosom_ke) == 1
anak(individu_ke,kromosom_ke) = 0;
else
anak(individu_ke,kromosom_ke) = 1;
end;
end;
% menjadikan individu anak sebagai individu orangtua pada generasi berikutnya
individu = anak;
% proses seleksi satu generasi berakhir
end;

% ----------------------------------------------
% mencetak result
% ----------------------------------------------
disp('x1 terbaik adalah: ');
disp(x1terbaik);
disp('x2 terbaik adalah: ');
disp(x2terbaik);
disp('Max terbaik adalah: ');
disp(max_fitness(gen));
disp('Dengan nilai fitness fungsi: ');
disp(fitness_terbaik(ngenerasi));

% ----------------------------------------------
% mengeplot hasil
% ----------------------------------------------
subplot(2,2,1);
plot(fitness_terbaik,'Color','red','linewidth',2);
hold on;
plot(max_fitness,'Color','blue');
title('Fitness Terbaik & Fitness Max','fontweight','bold');
xlabel('Generasi');
ylabel('Max f(x1,x2)');
legend('terbaik','maksimum','location','southoutside','orientation','horizontal');
hold off;

subplot(2,2,2);
plot(fitness_terbaik,'Color','red','linewidth',2);
hold on;
plot(rata_rata_fitness,'Color','blue');
title('Fitness Terbaik & Mean Fitness','fontweight','bold');
xlabel('Generasi');
ylabel('Mean f(x1,x2)');
legend('terbaik','mean','location','southoutside','orientation','horizontal');
hold off;
subplot(2,2,3);
plot(fitness_terbaik,'Color','red','linewidth',2);
hold on;
plot(min_fitness,'Color','blue');
title('Fitness Terbaik & Min Fitness','fontweight','bold');
xlabel('Generasi');
ylabel('Min f(x1,x2)');
legend('terbaik','minimum','location','southoutside','orientation','horizontal');
hold off;
subplot(2,2,4);
plot(fitness_terbaik,'Color','red','linewidth',2);
hold on;
plot(max_fitness,'Color','green');
plot(rata_rata_fitness,'Color','blue');
plot(min_fitness,'Color','black');
title('Fitness Terbaik & Max, Mean, Min Fitness','fontweight','bold');
xlabel('Generasi');
ylabel('f(x1,x2)');
legend('terbaik','maksimum','mean','minimum','location','southoutside','orientation','horizontal');
hold off;

%{


%}