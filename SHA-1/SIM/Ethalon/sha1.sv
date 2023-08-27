class sha1;
    function new();        
    endfunction //new()


    function bit [31:0] get_Ft(int iteration);
        if((iteration >= 0) && (iteration <= 19)) return 32'h5A827999;
        else if((iteration >= 20) && (iteration <= 39)) return 32'h6ED9EBA1;
        else if((iteration >= 40) && (iteration <= 59)) return 32'h8F1BBCDC;
        else if((iteration >= 60) && (iteration <= 79)) return 32'hCA62C1D6;
        else begin
            $fatal();
            return 32'h0;
        end
    endfunction


    function bit [4:0][31:0] sha1_calculate(string str);
        bit [4:0][31:0] sha1_result;
        
        int string_length = str.len();


        $display("String length = %0d", string_length);

    endfunction
    



endclass //sha1_calculate