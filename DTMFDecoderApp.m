classdef DTMFDecoderApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = private)
        UIFigure           matlab.ui.Figure
        StartButton        matlab.ui.control.Button
        AxesTimeDomain     matlab.ui.control.UIAxes
        AxesFreqDomain     matlab.ui.control.UIAxes
        DecodedOutputText  matlab.ui.control.Label
            TitleLabel             matlab.ui.control.Label
    RecordingIndicator     matlab.ui.control.Label
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: StartButton
        function StartButtonPushed(app, event)
            global tone_all h1 h3 h4 Decode_output
            Decode_output = [];
            output = [];
            fs = 8000;  % Sampling frequency

            %% Record Audio from Microphone
            recObj = audiorecorder(fs, 16, 1); % Create an audio recorder object
            disp('Start speaking.')
            app.RecordingIndicator.Text = 'Recording...';
            app.RecordingIndicator.FontColor = [1, 0, 0]; % Red color indicating recording
            recordblocking(recObj, 5); % Record for 5 seconds
            disp('End of Recording.');
            app.RecordingIndicator.Text = 'Recording stopped';
            app.RecordingIndicator.FontColor = [0, 0.5, 0]; % Dark green indicating not recording
            tone_all_2 = getaudiodata(recObj)'; 
            %% Filter Bank Design
            a697 = [1 -2*cos(2*pi*18/205) 1];
            a770 = [1 -2*cos(2*pi*20/205) 1];
            a852 = [1 -2*cos(2*pi*22/205) 1];
            a941 = [1 -2*cos(2*pi*24/205) 1];
            a1209 = [1 -2*cos(2*pi*31/205) 1];
            a1336 = [1 -2*cos(2*pi*34/205) 1];
            a1477 = [1 -2*cos(2*pi*38/205) 1];
            a1633 = [1 -2*cos(2*pi*42/205) 1];

            [w1, f] = freqz([1 -exp(-2*pi*18/205)], a697, 512, fs);
            [w2, f] = freqz([1 -exp(-2*pi*20/205)], a770, 512, fs);
            [w3, f] = freqz([1 -exp(-2*pi*22/205)], a852, 512, fs);
            [w4, f] = freqz([1 -exp(-2*pi*24/205)], a941, 512, fs);
            [w5, f] = freqz([1 -exp(-2*pi*31/205)], a1209, 512, fs);
            [w6, f] = freqz([1 -exp(-2*pi*34/205)], a1336, 512, fs);
            [w7, f] = freqz([1 -exp(-2*pi*38/205)], a1477, 512, fs);
            [w8, f] = freqz([1 -exp(-2*pi*42/205)], a1633, 512, fs);

            t = [0:length(tone_all_2)-1]/fs;
            plot(app.AxesTimeDomain, t, tone_all_2, 'Parent', app.AxesTimeDomain);
            grid(app.AxesTimeDomain, 'on');
            title(app.AxesTimeDomain, 'Signal tone');
            ylabel(app.AxesTimeDomain, 'Amplitude');
            xlabel(app.AxesTimeDomain, 'Time (second)');
            
            plot(app.AxesFreqDomain, f, abs(w1)/1000, f, abs(w2)/1000, f, abs(w3)/1000, f, abs(w4)/1000, f, abs(w5)/1000, f, abs(w6)/1000, f, abs(w7)/1000, f, abs(w8)/1000, 'Parent', app.AxesFreqDomain);
            grid(app.AxesFreqDomain, 'on');
            title(app.AxesFreqDomain, 'BPF frequency responses');
            xlabel(app.AxesFreqDomain, 'Frequency (Hz)');
            ylabel(app.AxesFreqDomain, 'Amplitude');
            legend(app.AxesFreqDomain, '697','770','852','941','1209','1336','1477','1633');
            axis(app.AxesFreqDomain, [500 2000 0 1]);
            
            %% Plot Frequency Spectrum using FFT
            N = length(tone_all_2);
            Y = fft(tone_all_2);
            f = (0:N-1)*(fs/N);
            amplitude = abs(Y)/N;
            plot(app.AxesFreqDomain, f, amplitude, 'Parent', app.AxesFreqDomain);
            grid(app.AxesFreqDomain, 'on');
            title(app.AxesFreqDomain, 'Frequency Domain Signal');
            xlabel(app.AxesFreqDomain, 'Frequency (Hz)');
            ylabel(app.AxesFreqDomain, 'Amplitude');
            axis(app.AxesFreqDomain, [0 fs/2 0 max(amplitude)]);
            
            %% Decode
            for ii = 0:(length(tone_all_2)/1421 - 1)
                tone = tone_all_2(1 + 1421*ii : 1421*(ii + 1));
                tone = tone(401:end);

                yDTMF = [tone 0];
                y697 = filter(1, a697, yDTMF);
                y770 = filter(1, a770, yDTMF);
                y852 = filter(1, a852, yDTMF);
                y941 = filter(1, a941, yDTMF);
                y1209 = filter(1, a1209, yDTMF);
                y1336 = filter(1, a1336, yDTMF);
                y1477 = filter(1, a1477, yDTMF);
                y1633 = filter(1, a1633, yDTMF);

                m(1) = sqrt(y697(206)^2 + y697(205)^2 - 2*cos(2*pi*18/205)*y697(206)*y697(205));
                m(2) = sqrt(y770(206)^2 + y770(205)^2 - 2*cos(2*pi*20/205)*y770(206)*y770(205));
                m(3) = sqrt(y852(206)^2 + y852(205)^2 - 2*cos(2*pi*22/205)*y852(206)*y852(205));
                m(4) = sqrt(y941(206)^2 + y941(205)^2 - 2*cos(2*pi*24/205)*y941(206)*y941(205));
                m(5) = sqrt(y1209(206)^2 + y1209(205)^2 - 2*cos(2*pi*31/205)*y1209(206)*y1209(205));
                m(6) = sqrt(y1336(206)^2 + y1336(205)^2 - 2*cos(2*pi*34/205)*y1336(206)*y1336(205));
                m(7) = sqrt(y1477(206)^2 + y1477(205)^2 - 2*cos(2*pi*38/205)*y1477(206)*y1477(205));
                m(8) = sqrt(y1633(206)^2 + y1633(205)^2 - 2*cos(2*pi*42/205)*y1633(206)*y1633(205));
                m = 2*m/205;
                th = sum(m)/4;  % based on empirical measurement
                f = [697 770 852 941 1209 1336 1477 1633];
                f1 = [0 4000];
                th = [th th];

                idx = find(m > th(1));
                if isempty(idx)
                    disp('No frequency detected above threshold.');
                    continue;
                end

                Determination = f(idx);
                if length(Determination) < 2
                    disp('Insufficient frequencies detected for DTMF decoding.');
                    continue;
                end

                switch Determination(1)
                    case 697
                        switch Determination(2)
                            case 1209
                                output = '1';
                            case 1336
                                output = '2';
                            case 1477
                                output = '3';
                            case 1633
                                output = 'A';
                        end
                    case 770
                        switch Determination(2)
                            case 1209
                                output = '4';
                            case 1336
                                output = '5';
                            case 1477
                                output = '6';
                            case 1633
                                output = 'B';
                        end
                    case 852
                        switch Determination(2)
                            case 1209
                                output = '7';
                            case 1336
                                output = '8';
                            case 1477
                                output = '9';
                            case 1633
                                output = 'C';
                        end
                    case 941
                        switch Determination(2)
                            case 1209
                                output = '*';
                            case 1336
                                output = '0';
                            case 1477
                                output = '#';
                            case 1633
                                output = 'D';
                        end
                end

                Decode_output = [Decode_output, output];

                disp(['Decoded output: ', Decode_output]);

                % Update app's DecodedOutputText
                app.DecodedOutputText.Text = ['Decoded Output: ', Decode_output];

                % Pause briefly to visualize
                pause(0.25);
            end
        end

        % Create UIFigure and components
        function createComponents(app)
            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 700 400];
            app.UIFigure.Name = 'DTMF Decoder App';

            % Create TitleLabel
            app.TitleLabel = uilabel(app.UIFigure);
            app.TitleLabel.HorizontalAlignment = 'center';
            app.TitleLabel.FontSize = 16;
            app.TitleLabel.FontWeight = 'bold';
            app.TitleLabel.Position = [100 370 500 20];
            app.TitleLabel.Text = 'DTMF Decoder App';


            % Create AxesTimeDomain
            app.AxesTimeDomain = uiaxes(app.UIFigure);
            app.AxesTimeDomain.Position = [50 150 300 200];

            % Create AxesFreqDomain
            app.AxesFreqDomain = uiaxes(app.UIFigure);
            app.AxesFreqDomain.Position = [400 150 300 200];

            % Create StartButton
            app.StartButton = uibutton(app.UIFigure, 'push');
            app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @StartButtonPushed, true);
            app.StartButton.Position = [100 50 100 30];
            app.StartButton.Text = 'Start';

            % Create DecodedOutputText
            app.DecodedOutputText = uilabel(app.UIFigure);
            app.DecodedOutputText.Position = [230 50 400 30];
            app.DecodedOutputText.Text = 'Decoded Output: ';
            app.DecodedOutputText.FontSize = 12;

            % Create RecordingIndicator
            app.RecordingIndicator = uilabel(app.UIFigure);
            app.RecordingIndicator.HorizontalAlignment = 'center';
            app.RecordingIndicator.FontSize = 12;
            app.RecordingIndicator.Position = [250 50 600 30];
            app.RecordingIndicator.Text = 'Not Recording';
            app.RecordingIndicator.FontColor = [0, 0.5, 0]; % Dark green color
        end

    end

    % App initialization and construction
    methods (Access = public)

        % Construct app
        function app = DTMFDecoderApp()
            % Create and configure components
            createComponents(app);

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end

    end
end
