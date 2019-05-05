%% int variables
d=dir;
s=size(d);
n=s(1)-3;
k=2;

%% filtering hidden files
  if strcmp(d(3).name, '.DS_Store');
    n=n-1;
    k=k+1;
  end

  if strcmp(d(3).name, 'data_read_CBL.m');
    k=k+1;
  end

  if strcmp(d(4).name, 'data_read_CBL.m');
    k=k+1;
  end

dati=zeros(1,n);
w=zeros(1,n);

%% start reading files
  for(i=1:n)
    d=dir;
    file_name=getfield(d(i+k),'name');

%% filtering txt line in files
    t=0;
    fid=fopen(file_name);
    tline=fgetl(fid);
    line1='  Part Instance  Element ID        Type         Int. Pt.  S, Max. Principal';
    line2='  Part Instance  Element ID        Type         Int. Pt.         S, Mises';
    line3='  Part Instance  Element ID        Type       Int. Pt.       S, Mises';
    line4='  Part Instance  Element ID        Type        Int. Pt.  S, Max. Principal';
    line5='  Part Instance  Element ID        Type        Int. Pt.        S, Mises';
    while ischar(tline)
      t=t+1;
      if ( (strcmp(tline,line1)) || (strcmp(tline,line2)) || (strcmp(tline,line3)) || (strcmp(tline,line4)) || (strcmp(tline,line5)) );
        w(i)=t+1;
      end
      tline=fgetl(fid);
    end

%% make vactor data mean
    [a1 b2 c3 d4 e5 f6]=textread(file_name, '%s %s %s %s %f %f', 'headerlines', w(i));
    dati(i)=mean(e5);

  end

%% make percentual increase
perc=zeros(1,n-1);
  for(q=2:n)
    primo=dati(q-1);
    secondo=dati(q);
    dato=((secondo/primo)*100)-100;
    perc(q-1)=dato;
  end
disp(file_name)
perc

%% plotting data
% POLYFIT y=dati;p=polyfit(x,y,4);x1=linspace(1,n,100);y1=polyval(p,x1);
figure('pos',[10 10 1200 300]);
x=linspace(1,n,n);
y=dati;

subplot(1,3,1);
plot(x,y);
grid on;
xlabel('Steps');
ylabel('Load value (MPa)')

subplot(1,3,2);
plot(ne,dati,'b','linewidth',3);
grid on;
ylabel('Load value (MPa)')
xlabel('Number of elements');

ne2=zeros(n-1,1);
  for (u=1:n-1)
    ne2(u)=ne(u+1);
  end

subplot(1,3,3);
plot(ne2,perc,'g','linewidth',3);
hold on; yx= @(x) 5;
fplot(yx,'r--','linewidth',2);
grid on;
ylabel('Incremental percentual');
xlabel('Number of elements');
