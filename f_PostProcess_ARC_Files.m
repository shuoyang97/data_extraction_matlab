% Author: Christian Siedbürger, Institut für Produktionstechnik und Umformmaschinen

%% function f_PostProcess_ARC_Files

function [Daten] = f_PostProcess_ARC_Files(Daten,j,r_lim,z_lim,r_lim_1D,z_lim_1D,r_Aufloesung_1D,Aufloesung_2D,Modus2D)

k_Faktor = 0.9;

%% Nachbearbeitung der DatensÃ¤tze fÃ¼r Fz

Felder = fieldnames(Daten(j).Kraft_Fz_Probe);

for ij = 1:length(Felder)
       Daten(j).Kraft_Fz_Max(ij).Name = Felder{ij};
       Daten(j).Kraft_Fz_Max(ij).MaxFz = max([Daten(j).Kraft_Fz_Probe.(Felder{ij})]);
       Daten(j).Kraft_Fz_Max(ij).MinFz = min([Daten(j).Kraft_Fz_Probe.(Felder{ij})]);
       Daten(j).Kraft_Fz_Max(ij).MeanFz = mean([Daten(j).Kraft_Fz_Probe.(Felder{ij})]);

       Werte = abs([Daten(j).Kraft_Fz_Probe.(Felder{ij})]);
        
       Groesser_als_X = find(Werte >= 2);
       Daten(j).Kraft_Fz_Max(ij).MeanFz_2kN = mean(Werte(Groesser_als_X));
       
end

%% Bezeichnung

Daten(j).r_mm = Daten(j).ArcData_100P.x_Korr*1000; %Umrechnen in mm
Daten(j).z_mm = Daten(j).ArcData_100P.z_Korr*1000; %Umrechnen in mm
Daten(j).AX_ES_MPA = Daten(j).ArcData_100P.TZZ/1000000; %in MPa
Daten(j).TANG_ES_MPA = Daten(j).ArcData_100P.TYY/1000000; %in MPa
Daten(j).RAD_ES_MPA = Daten(j).ArcData_100P.TXX/1000000; %in MPa
Daten(j).VG_ES_MPA = Daten(j).ArcData_100P.EFSTRT/1000000; %in MPa
Daten(j).Temperatur = Daten(j).ArcData_100P.TEMPTURE - 273.15;
Daten(j).Umformgrad = Daten(j).ArcData_100P.EFFPLS;
Daten(j).Fliessspannung = Daten(j).ArcData_100P.YLDSTRES/1000000; %in MPa

Daten(j).AX_OB_ES_MPA = Daten(j).ArcData_100P.TZZ/1000000;
Daten(j).TANG_OB_ES_MPA = Daten(j).ArcData_100P.TYY/1000000;
Daten(j).RAD_OB_ES_MPA = Daten(j).ArcData_100P.TXX/1000000;
Daten(j).VG_OB_ES_MPA = Daten(j).ArcData_100P.EFSTRT/1000000;
Daten(j).Temperatur_OB = Daten(j).ArcData_100P.TEMPTURE - 273.15;
Daten(j).Umformgrad_OB = Daten(j).ArcData_100P.EFFPLS;
Daten(j).Fliessspannung_OB = Daten(j).ArcData_100P.YLDSTRES/1000000; %in MPa


%Bestimmung der OberflÃ¤chenspannungen
[k,av] = boundary([Daten(j).r_mm, Daten(j).z_mm],0.95);

Daten(j).OB_r_mm = Daten(j).r_mm(k);
Daten(j).OB_z_mm = Daten(j).z_mm(k);

Daten(j).AX_OB_ES_MPA = Daten(j).AX_ES_MPA(k);
Daten(j).TANG_OB_ES_MPA = Daten(j).TANG_ES_MPA(k);
Daten(j).RAD_OB_ES_MPA = Daten(j).RAD_ES_MPA(k);
Daten(j).VG_OB_ES_MPA = Daten(j).VG_ES_MPA(k);
Daten(j).Temperatur_OB = Daten(j).Temperatur(k);
Daten(j).Umformgrad_OB = Daten(j).Umformgrad(k);
Daten(j).Fliessspannung_OB = Daten(j).Fliessspannung(k);

r_OB = Daten(j).OB_r_mm; 
z_OB = Daten(j).OB_z_mm; 

%Bestimmung der Spannungen direkt an der Messzone

r_find = find(r_OB < r_lim(2) & r_OB > r_lim(1));
z_find = find(z_OB(r_find) > z_lim(1) & z_OB(r_find) < z_lim(2));

Daten(j).OB_r_mm = Daten(j).OB_r_mm(r_find);
Daten(j).OB_z_mm = Daten(j).OB_z_mm(r_find);

Daten(j).AX_OB_ES_MPA = Daten(j).AX_OB_ES_MPA(r_find);
Daten(j).TANG_OB_ES_MPA = Daten(j).TANG_OB_ES_MPA(r_find);
Daten(j).RAD_OB_ES_MPA = Daten(j).RAD_OB_ES_MPA(r_find);
Daten(j).VG_OB_ES_MPA = Daten(j).VG_OB_ES_MPA(r_find);
Daten(j).Temperatur_OB = Daten(j).Temperatur_OB(r_find);
Daten(j).Umformgrad_OB = Daten(j).Umformgrad_OB(r_find);
Daten(j).Fliessspannung_OB = Daten(j).Fliessspannung_OB(r_find);

Daten(j).OB_r_mm = Daten(j).OB_r_mm(z_find);
Daten(j).OB_z_mm = Daten(j).OB_z_mm(z_find);

Daten(j).AX_OB_ES_MPA = Daten(j).AX_OB_ES_MPA(z_find);
Daten(j).TANG_OB_ES_MPA = Daten(j).TANG_OB_ES_MPA(z_find);
Daten(j).RAD_OB_ES_MPA = Daten(j).RAD_OB_ES_MPA(z_find);
Daten(j).VG_OB_ES_MPA = Daten(j).VG_OB_ES_MPA(z_find);
Daten(j).Temperatur_OB = Daten(j).Temperatur_OB(z_find);
Daten(j).Umformgrad_OB = Daten(j).Umformgrad_OB(z_find);
Daten(j).Fliessspannung_OB = Daten(j).Fliessspannung_OB(z_find);

Daten(j).Temperatur_OB_mean = mean(Daten(j).Temperatur_OB);
Daten(j).AX_OB_ES_MPA_mean = mean(Daten(j).AX_OB_ES_MPA);
Daten(j).AX_OB_ES_MPA_range = range(Daten(j).AX_OB_ES_MPA);
Daten(j).Diameter_mean = mean(Daten(j).OB_r_mm);
Daten(j).Umformgrad_OB_mean = mean(Daten(j).Umformgrad_OB);
Daten(j).Fliessspannung_OB_mean = mean(Daten(j).Fliessspannung_OB);

%% Ãœbersicht Ã¼ber Konfiguration

% Daten(j).Reibung = Daten(j).Input(6).FrictionMue;
% Daten(j).Material = Daten(j).Input(8).Material;
% Daten(j).Gegenkraft = max(Daten(j).Input(2).FederY);
% Daten(j).Mesh = Daten(j).Input(8).MeshSize; 
% Daten(j).Legend = append('Âµ = ',num2str(Daten(j).Reibung),', ',num2str(max(Daten(j).Input(2).FederY)),'kN, ',num2str(Daten(j).Material),', ',num2str(Daten(j).Mesh));

%% Bestimmung der Spannungen als 1-D-Plot an ausgewÃ¤hlter Stelle

r_find = find(Daten(j).r_mm < r_lim_1D(2) & Daten(j).r_mm > r_lim_1D(1));
z_find = find(Daten(j).z_mm(r_find) > z_lim_1D(1) & Daten(j).z_mm(r_find) < z_lim_1D(2));

Daten(j).r_mm_1D = Daten(j).r_mm(r_find);
Daten(j).z_mm_1D = Daten(j).z_mm(r_find);

Daten(j).AX_1D_ES_MPA = Daten(j).AX_ES_MPA(r_find);
Daten(j).TANG_1D_ES_MPA = Daten(j).TANG_ES_MPA(r_find);
Daten(j).RAD_1D_ES_MPA = Daten(j).RAD_ES_MPA(r_find);
Daten(j).VG_1D_ES_MPA = Daten(j).VG_ES_MPA(r_find);
Daten(j).Temperatur_1D = Daten(j).Temperatur(r_find);

Daten(j).r_mm_1D = Daten(j).r_mm_1D(z_find);
Daten(j).z_mm_1D = Daten(j).z_mm_1D(z_find);

Daten(j).AX_1D_ES_MPA = Daten(j).AX_1D_ES_MPA(z_find);
Daten(j).TANG_1D_ES_MPA = Daten(j).TANG_1D_ES_MPA(z_find);
Daten(j).RAD_1D_ES_MPA = Daten(j).RAD_1D_ES_MPA(z_find);
Daten(j).VG_1D_ES_MPA = Daten(j).VG_1D_ES_MPA(z_find);
Daten(j).Temperatur_1D = Daten(j).Temperatur_1D(z_find);

r_min = min(Daten(j).r_mm_1D);
r_max = max(Daten(j).r_mm_1D);
r = linspace(r_min,r_max,r_Aufloesung_1D);

%% 

[fitresult, gof] = createFit(Daten(j).r_mm_1D, Daten(j).AX_1D_ES_MPA);
Daten(j).AX_1D_ES_MPA = fitresult(r);

[fitresult, gof] = createFit(Daten(j).r_mm_1D, Daten(j).TANG_1D_ES_MPA);
Daten(j).TANG_1D_ES_MPA = fitresult(r);

[fitresult, gof] = createFit(Daten(j).r_mm_1D, Daten(j).RAD_1D_ES_MPA);
Daten(j).RAD_1D_ES_MPA = fitresult(r);

[fitresult, gof] = createFit(Daten(j).r_mm_1D, Daten(j).VG_1D_ES_MPA);
Daten(j).VG_1D_ES_MPA = fitresult(r);

Daten(j).r_mm_1D_int = r; 

%% 2D-Interpolation

if Modus2D == 1

[Daten(j).r_2D_mm,Daten(j).z_2D_mm,Daten(j).AX_2D_ES_MPA] = f_2D_data(Daten,j,k_Faktor,'AX_ES_MPA',Aufloesung_2D);
[Daten(j).r_2D_mm,Daten(j).z_2D_mm,Daten(j).TANG_2D_ES_MPA] = f_2D_data(Daten,j,k_Faktor,'TANG_ES_MPA',Aufloesung_2D);
[Daten(j).r_2D_mm,Daten(j).z_2D_mm,Daten(j).RAD_2D_ES_MPA] = f_2D_data(Daten,j,k_Faktor,'RAD_ES_MPA',Aufloesung_2D);
[Daten(j).r_2D_mm,Daten(j).z_2D_mm,Daten(j).VG_2D_ES_MPA] = f_2D_data(Daten,j,k_Faktor,'VG_ES_MPA',Aufloesung_2D);
[Daten(j).r_2D_mm,Daten(j).z_2D_mm,Daten(j).Temperatur_2D] = f_2D_data(Daten,j,k_Faktor,'Temperatur',Aufloesung_2D);

end


end