function export_PMF(data)
    % Questa funzione prende una struct "data" e la salva in un file .pmf
    % seguendo la stessa struttura della load_PMF_V2().
    % Il nome del file sarà automaticamente data.nome + '_set-up.pmf'.
    % L'utente sceglie solo la cartella di salvataggio.
    %
    % Author: Antonio Filianoti (modificato)

    %% SELEZIONE CARTELLA
    folder = uigetdir(pwd, 'Seleziona la cartella dove salvare il file PMF');
    if folder == 0
        disp('Operazione annullata.');
        return;
    end

    %% COSTRUZIONE NOME FILE AUTOMATICO
    if isfield(data, 'nome')
        filename = [data.nome '_set-up.pmf'];
    else
        error('La struct "data" deve contenere il campo "nome".');
    end
    filepath = fullfile(folder, filename);

    %% COSTRUZIONE VETTORE DATI
    values = zeros(1,113);  % massimo indice usato in load_PMF_V2 = 113

    % FRONT SUSPENSION
    values(1)  = data.FrontSuspension.ForksLength;
    values(2)  = data.FrontSuspension.ForksVerticalOffset;
    values(3)  = data.FrontSuspension.Compression;
    values(4)  = data.FrontSuspension.ForksMaxCompression;
    values(5)  = data.FrontSuspension.PlatesTopThickness;
    values(6)  = data.FrontSuspension.OffsetTop;
    values(7)  = data.FrontSuspension.OffsetTopMax;
    values(8)  = data.FrontSuspension.OffsetTopMin;
    values(9)  = data.FrontSuspension.PlatesBottomThickness;
    values(10) = data.FrontSuspension.OffsetBottom;
    values(11) = data.FrontSuspension.OffsetBottomMax;
    values(12) = data.FrontSuspension.OffsetBottomMin;
    values(13) = data.FrontSuspension.PlatesForkOffset;
    values(14) = data.FrontSuspension.FootOffset;
    values(15) = data.FrontSuspension.ForksWheelbase;
    % 16 null -> resta zero
    values(17) = data.FrontSuspension.COGX;
    values(18) = data.FrontSuspension.COGZ;
    values(19) = data.FrontSuspension.COGMass;
    % 20 null -> resta zero

    % REAR SUSPENSION
    values(21) = data.RearSuspension.LengthRearSuspension;
    values(22) = data.RearSuspension.LengthMaxRearSuspension;
    values(23) = data.RearSuspension.LengthMinRearSuspension;
    values(24) = data.RearSuspension.Compression;
    values(25) = data.RearSuspension.MaxCompressionRearSuspension;
    % 26 null -> resta zero

    % Tipo sospensione
    values(33) = data.RearSuspension.Type;
    if data.RearSuspension.Type == 4
        values(27) = data.RearSuspension.TriangleSuspFrame;
        values(28) = data.RearSuspension.TriangleFrameRod;
        values(29) = data.RearSuspension.TriangleRodSusp;
    elseif data.RearSuspension.Type == 2
        values(27) = data.RearSuspension.TriangleSwingSusp;
        values(28) = data.RearSuspension.TriangleSwingRod;
        values(29) = data.RearSuspension.TriangleRodSusp;
    end
    values(30) = data.RearSuspension.RodLength;
    values(31) = data.RearSuspension.MaxRodLength;
    values(32) = data.RearSuspension.MinRodLength;

    % FRAME
    values(36) = data.Frame.LengthRear2SteeringHead;
    values(37) = data.Frame.HeightSteeringHead;
    values(38) = data.Frame.DistSteeringHead;
    % 39-40 null
    values(41) = data.Frame.SteeringAxisTopOffset;
    values(42) = data.Frame.SteeringAxisTopOffsetMax;
    values(43) = data.Frame.SteeringAxisTopOffsetMin;
    % 44-45 null
    values(46) = data.Frame.SteeringAxisBottomOffset;
    values(47) = data.Frame.SteeringAxisBottomOffsetMax;
    values(48) = data.Frame.SteeringAxisBottomOffsetMin;
    % 49-50 null
    values(51) = data.Frame.AttFrameSupX;
    values(52) = data.Frame.AttFrameSupZ;
    values(53) = data.Frame.AngleAttFrameSupOffset;
    values(54) = data.Frame.AttFrameSupOffset;
    values(55) = data.Frame.AttFrameSupOffsetMax;
    values(56) = data.Frame.AttFrameInfX;
    values(57) = data.Frame.AttFrameInfZ;
    values(58) = data.Frame.AngleAttFrameInfOffset;
    values(59) = data.Frame.AttFrameInfOffset;
    values(60) = data.Frame.AttFrameInfOffsetMax;
    values(61) = data.Frame.PivotOffsetX;
    values(62) = data.Frame.PivotOffsetZ;
    values(63) = data.Frame.AnglePivotOffset;
    % 64-65 null
    values(66) = data.Frame.COGX;
    values(67) = data.Frame.COGZ;
    values(68) = data.Frame.COGMass;
    % 69-70 null
    values(71) = data.Frame.PinionX;
    values(72) = data.Frame.PinionZ;
    values(73) = data.Frame.PinionY;
    % 74-75 null
    values(76) = data.Frame.FairingX1;
    values(77) = data.Frame.FairingZ1;
    values(78) = data.Frame.FairingX2;
    values(79) = data.Frame.FairingZ2;
    % 80 null

    % SWINGARM
    values(81) = data.Swingarm.Length;
    values(82) = data.Swingarm.AngleOffset;
    values(83) = data.Swingarm.Offset;
    values(84) = data.Swingarm.OffsetMax;
    % 85 null
    values(86) = data.Swingarm.AttSwingInfX;
    values(87) = data.Swingarm.AttSwingInfZ;
    values(88) = data.Swingarm.AngleAttSwingInf;
    values(89) = data.Swingarm.OffsetAttSwingInf;
    values(90) = data.Swingarm.OffsetAttSwingInfMax;
    values(91) = data.Swingarm.AttSwingSupX;
    values(92) = data.Swingarm.AttSwingSupZ;
    values(93) = data.Swingarm.AngleAttSwingSup;
    values(94) = data.Swingarm.OffsetAttSwingSup;
    values(95) = data.Swingarm.OffsetAttSwingSupMax;
    values(96) = data.Swingarm.COGX;
    values(97) = data.Swingarm.COGZ;
    values(98) = data.Swingarm.COGMass;
    % 99-100 null

    % WHEELS
    values(101) = data.Wheels.FrontSize;
    values(102) = data.Wheels.FrontMass;
    values(103) = data.Wheels.RearSize;
    values(104) = data.Wheels.RearMass;

    % TRANSMISSION
    values(111) = data.Transmission.FinalPinion;
    values(112) = data.Transmission.FinalSprocket;
    values(113) = data.Transmission.FinalChainModule;

    %% SCRITTURA FILE
    fid = fopen(filepath, 'w');
    if fid == -1
        error('Impossibile aprire il file per scrittura.');
    end

    for i = 1:length(values)
        fprintf(fid, '%.6f\n', values(i));
    end
    fclose(fid);

    disp(['File salvato in: ' filepath]);
end
