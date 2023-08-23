function [return1, return2] = create_dataset(Daten)
    
%     bar = waitbar(0, 'Generating...');
    for j = 1:size(Daten,2)
        r_Aufloesung_1D = 100;
        Aufloesung_2D = [400 400];
         
        r_lim = [5,5.8];
        z_lim = [40 70];
         
        r_lim_1D = [0,20];
        z_lim_1D = [40 70];
         
        [Daten] = f_PostProcess_ARC_Files(Daten,j,r_lim,z_lim,r_lim_1D, ...
            z_lim_1D,r_Aufloesung_1D,Aufloesung_2D,0);
%         waitbar(j/size(Daten,2), bar);
    end
    
    len_data = length(Daten);
        
%     create space to save data points
    matrize_grad = [];
    material = [];
    temperature = [];
    fri_m_data = [];
    fri_mue_data = [];
    Punchforce_data = [];
    Mesh_Matrize = [];
    Mesh_Probe = [];
    Remeshing_Probe = [];

    Temperatur_OB_mean = [];
    Diameter_mean = [];
    Umformgrad_OB_mean = [];
    Fliessspannung_OB_mean = [];
    
%     loop for extract data from data structure
    for i = 1:len_data 
        input = Daten(i).Input;
        len = length(input);
        
        fri_m = [];
        fri_mue = [];

%         material_i = 'Material_' + input(8).Material;
%         material = [material; material_i];
        Legend = convertStringsToChars(Daten(i).Legend);
        matrize_grad = [matrize_grad; Legend(11:12)];
        material = [material; Daten(i).Konfiguration.Object_Probe_SF(134, 2)];
        temperature = [temperature; Daten(i).ArcData_30P(1).TEMPTURE(1)];
        Punchforce_data = [Punchforce_data; Daten(i).Kraft_Fz_Max(5).MaxFz];
        Mesh_Matrize = [Mesh_Matrize; input(7).MeshSize];
        Mesh_Probe = [Mesh_Probe; input(8).MeshSize];
        Remeshing_Probe = [Remeshing_Probe; input(8).Remeshing];

        Temperatur_OB_mean = [Temperatur_OB_mean; Daten(i).Temperatur_OB_mean];
        Diameter_mean = [Diameter_mean; Daten(i).Diameter_mean];
        Umformgrad_OB_mean = [Umformgrad_OB_mean; Daten(i).Umformgrad_OB_mean];
        Fliessspannung_OB_mean = [Fliessspannung_OB_mean; Daten(i).Fliessspannung_OB_mean];
        
        for j = 1:len
            fri_m = [fri_m; input(j).FrictionM];
            fri_mue = [fri_mue;input(j).FrictionMue]; 
        end
        
        fri_m_data = [fri_m_data, fri_m];
        fri_mue_data = [fri_mue_data, fri_mue];
    
    end
    
%     transpose data arrays
    fri_m_data = transpose(fri_m_data);
    fri_mue_data = transpose(fri_mue_data);
    
    
%     concentrate data arrays
%     input_data = cat(2, fri_m_data, fri_mue_data, Punchforce_data, ...
%         Mesh_Matrize, Mesh_Probe, Remeshing_Probe, temperature, material); 
    input_data = cat(2, fri_m_data, fri_mue_data, Punchforce_data, ...
        Mesh_Matrize, temperature, matrize_grad, material); 
    output_data = cat(2, Temperatur_OB_mean, Diameter_mean, ...
        Umformgrad_OB_mean, Fliessspannung_OB_mean);
    
    return1 = input_data;
    return2 = output_data;   
    
    return

end