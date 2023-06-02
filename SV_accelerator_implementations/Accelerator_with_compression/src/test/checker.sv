class Checker #(config_t cfg);

  localparam COUNT_ALL_OUTPUT_MASKS = (((cfg.FEATURE_MAP_WIDTH-1)/16+1)*(cfg.FEATURE_MAP_HEIGHT)*cfg.OUTPUT_NB_CHANNELS/8);

  mailbox #(Transaction_Output_Encoded#(cfg)) mon2chk_encoded;
  mailbox #(Transaction_Output_Masks#(cfg)) mon2chk_masks;
  mailbox #(bit) chk2scb;
  
  logic [cfg.MEM_BW-1:0] reference_output_masks [0:((cfg.FEATURE_MAP_WIDTH-1)/16+1)*(cfg.FEATURE_MAP_HEIGHT)*cfg.OUTPUT_NB_CHANNELS/8-1];
  logic [cfg.MEM_BW-1:0] reference_output_encoded [0:((cfg.FEATURE_MAP_WIDTH-1)/16+1)*(cfg.FEATURE_MAP_HEIGHT)*cfg.OUTPUT_NB_CHANNELS-1];
  bit verbose= 0;
  int fd;
  int counter;

  bit output_tested_masks [0:((cfg.FEATURE_MAP_WIDTH-1)/16+1)*(cfg.FEATURE_MAP_HEIGHT)*cfg.OUTPUT_NB_CHANNELS/8-1];
  bit output_tested_encoded [0:((cfg.FEATURE_MAP_WIDTH-1)/16+1)*(cfg.FEATURE_MAP_HEIGHT)*cfg.OUTPUT_NB_CHANNELS-1];

  int count_masks;
  int count_encoded;

  bit no_error_in_full_output_frame_masks;
  bit no_error_in_full_output_frame_encoded;

  time starttime;

  function new(
      mailbox #(Transaction_Output_Encoded#(cfg)) m2c_encoded,
      mailbox #(Transaction_Output_Masks#(cfg)) m2c_masks,
      mailbox #(bit) c2s
    );
    mon2chk_encoded = m2c_encoded;
    mon2chk_masks   = m2c_masks;
    chk2scb         = c2s;
  endfunction : new


  task run;

    fd = $fopen ("outputs_mask.txt", "r");
    if (fd) $display("File was opened succesfully : %0d", fd);
    else $display("File was NOT opened succesfully : %0d", fd);

    for(int i=0;i<((cfg.FEATURE_MAP_WIDTH-1)/16+1)*(cfg.FEATURE_MAP_HEIGHT)*cfg.OUTPUT_NB_CHANNELS/8; i++) begin
      string line;
      logic [cfg.MEM_BW-1:0] output_masks; 
      $fgets(line, fd);
      //$display("Line read : %s", line);
      output_masks = line.atobin();
      reference_output_masks[i] = output_masks;
    end
    $fclose(fd);

    fd = $fopen ("outputs_encoded.txt", "r");
    if (fd) $display("File was opened succesfully : %0d", fd);
    else $display("File was NOT opened succesfully : %0d", fd);

    counter = 0;
    while (!$feof(fd)) begin 
      string line;
      logic [cfg.MEM_BW-1:0] output_encoded; 
      $fgets(line, fd);
      //$display("Line read : %s", line);
      output_encoded = line.atobin();
      reference_output_encoded[counter] = output_encoded;
      counter += 1;
    end
    $fclose(fd);
    forever 
    begin
      // keep track of how many words are tested so far
      count_masks= 0;
      count_encoded = 0;

      no_error_in_full_output_frame_masks = 1;
      no_error_in_full_output_frame_encoded = 1;

      // output_tested_masks and output_tested_encoded makes sure that the same output word is not tested again
      
      // initialize
      for(int i=0;i<((cfg.FEATURE_MAP_WIDTH-1)/16+1)*(cfg.FEATURE_MAP_HEIGHT)*cfg.OUTPUT_NB_CHANNELS/8; i++) begin
          output_tested_masks[i] = 0;
      end

      // initialize
      for(int i=0;i<((cfg.FEATURE_MAP_WIDTH-1)/16+1)*(cfg.FEATURE_MAP_HEIGHT)*cfg.OUTPUT_NB_CHANNELS; i++) begin
          output_tested_encoded[i] = 0;
      end
      
      fork 
      begin 
        starttime = $time();
        forever // run until all the words for the current output are checked
        begin 
          bit output_correct_masks;
          Transaction_Output_Masks #(cfg) tract_output_masks;
          mon2chk_masks.get(tract_output_masks);

          // Make sure there are no Xs
          assert (!$isunknown(tract_output_masks.output_data_masks)) else $stop;
          assert (!$isunknown(tract_output_masks.index)) else $stop;
          assert (!$isunknown(reference_output_masks[tract_output_masks.index])) else $stop;

          assert (!output_tested_masks[tract_output_masks.index]) else
          begin
            $error("\
              An output word is being received twice, or dimensions output_x, etc are corrupted.\n\
              Possible problem with Monitor or driving of output_valid from DUT.\n\
              output_valid should be high for only 1 cycle for every valid output_data\n");
            $stop;
          end
          output_tested_masks[tract_output_masks.index] = 1;
          //$display("For ouput_y: %d, output_x: %d, output_ch: %d : expected_golden: %d, reference_output: %d, result: %d", tract_output.output_y, tract_output.output_x, tract_output.output_ch, expected, reference_output[tract_output.output_y][tract_output.output_x][tract_output.output_ch], tract_output.output_data);
          output_correct_masks = (reference_output_masks[tract_output_masks.index] == tract_output_masks.output_data_masks);
          no_error_in_full_output_frame_masks = no_error_in_full_output_frame_masks & output_correct_masks;
          if(output_correct_masks) begin
            if (verbose) $display("[CHK] Result is correct");
          end else begin
            $display("[CHK] Result is incorrect");
            $stop;
          end
          count_masks++;
          if (count_masks == COUNT_ALL_OUTPUT_MASKS) begin
            break;
          end
        end
      end
      begin 
        forever // run until all the words for the current output are checked
        begin 
          bit output_correct_encoded;
          Transaction_Output_Encoded #(cfg) tract_output_encoded;
          mon2chk_encoded.get(tract_output_encoded);

          // Make sure there are no Xs
          assert (!$isunknown(tract_output_encoded.output_data_encoded)) else $stop;
          assert (!$isunknown(tract_output_encoded.index)) else $stop;
          assert (!$isunknown(reference_output_encoded[tract_output_encoded.index])) else $stop;

          assert (!output_tested_encoded[tract_output_encoded.index]) else
          begin
            $error("\
              An output word is being received twice, or dimensions output_x, etc are corrupted.\n\
              Possible problem with Monitor or driving of output_valid from DUT.\n\
              output_valid should be high for only 1 cycle for every valid output_data\n");
            $stop;
          end
          output_tested_encoded[tract_output_encoded.index] = 1;
          //$display("For ouput_y: %d, output_x: %d, output_ch: %d : expected_golden: %d, reference_output: %d, result: %d", tract_output.output_y, tract_output.output_x, tract_output.output_ch, expected, reference_output[tract_output.output_y][tract_output.output_x][tract_output.output_ch], tract_output.output_data);
          output_correct_encoded = (reference_output_encoded[tract_output_encoded.index] == tract_output_encoded.output_data_encoded);
          no_error_in_full_output_frame_encoded = no_error_in_full_output_frame_encoded & output_correct_encoded;
          if(output_correct_encoded) begin
            if (verbose) $display("[CHK] Result is correct");
          end else begin
            $display("[CHK] Result is incorrect");
            $stop;
          end
          count_encoded++;
          if (count_encoded == counter-1) begin
            break;
          end
        end       
      end
      join
      $display("\n\n------------------\nLATENCY: output monitored in %t\n------------------\n", $time() - starttime);

      $display("------------------\nENERGY:  %0d\n------------------\n", tbench_top.energy);

      $display("------------------\nENERGYxLATENCY PRODUCT (/1e9):  %0d\n------------------\n", (longint'(tbench_top.energy) * ($time() - starttime))/1e9);

      tbench_top.energy=0; 
      if(no_error_in_full_output_frame_encoded && no_error_in_full_output_frame_masks) begin
        $display("[CHK] all the words in the current output are correct");
      end else begin
        $display("[CHK] NOT all the words in the current output are correct");
      end
      chk2scb.put(no_error_in_full_output_frame_encoded && no_error_in_full_output_frame_masks);
    end
  endtask
endclass : Checker
