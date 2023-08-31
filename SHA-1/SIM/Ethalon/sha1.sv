class sha1;
    function new();        
    endfunction //new()


    function bit [31:0] get_Ft(int iteration, bit [31:0] B, bit [31:0] C, bit [31:0] D);
        if((iteration >= 0) && (iteration <= 19)) return ((B & C) | (~B & D));
        else if((iteration >= 20) && (iteration <= 39)) return (B ^ C ^ D);
        else if((iteration >= 40) && (iteration <= 59)) return ((B & C) | (B & D) | (C & D));
        else if((iteration >= 60) && (iteration <= 79)) return (B ^ C ^ D);
        else begin
            $fatal();
            return 32'h0;
        end
    endfunction

    function bit [31:0] get_Kt(int iteration);
        if((iteration >= 0) && (iteration <= 19)) return 32'h5A827999;
        else if((iteration >= 20) && (iteration <= 39)) return 32'h6ED9EBA1;
        else if((iteration >= 40) && (iteration <= 59)) return 32'h8F1BBCDC;
        else if((iteration >= 60) && (iteration <= 79)) return 32'hCA62C1D6;
        else begin
            $fatal();
            return 32'h0;
        end        
    endfunction
    

    function bit [31:0] SHA1CircularShift(int bits, bit [31:0] word);
        int bits_mod;
        bits_mod = bits % 32;
        
        if(bits_mod == 0) return word;
        //else return {word[31-bits_mod:0], word[31:31-bits_mod+1]};//QuestaSim - error
        else return (32'(word << bits) | 32'(word >> (32-bits)));
    endfunction



    function bit [4:0][31:0] sha1_calculate(string str);
        bit [4:0][31:0] sha1_result;
        int string_length = str.len();
        int align_string_length;
        bit [7:0][7:0] len_in_bit;//длина в битах
        bit [7:0] message_array [];//create message byte array
        bit [79:0][31:0] Wt;

        bit [31:0] temp;
        bit [31:0] A, B, C, D, E;

        align_string_length = string_length + 1;//add bit one
        
        if(align_string_length % 64 > 55) begin//проверяем, влезает ли 64-битная длина
            align_string_length += 64 - (align_string_length % 64) + 64;//если не влезает, то добавляем 
        end
        else begin
            align_string_length += 64 - (align_string_length % 64);
        end

        message_array = new[align_string_length];

        for(int i = 0; i < align_string_length; i++) begin
            if(i < string_length) message_array[i] = str[i];
            else if(i == string_length) message_array[i] = 8'h80;
            else message_array[i] = 8'h0;
        end

        //add length
        len_in_bit = string_length * 8;
        message_array[align_string_length-8] = len_in_bit[7];
        message_array[align_string_length-7] = len_in_bit[6];
        message_array[align_string_length-6] = len_in_bit[5];
        message_array[align_string_length-5] = len_in_bit[4];
        message_array[align_string_length-4] = len_in_bit[3];
        message_array[align_string_length-3] = len_in_bit[2];
        message_array[align_string_length-2] = len_in_bit[1];
        message_array[align_string_length-1] = len_in_bit[0];



        sha1_result[4] = 32'h67452301;
        sha1_result[3] = 32'hEFCDAB89;
        sha1_result[2] = 32'h98BADCFE;
        sha1_result[1] = 32'h10325476;
        sha1_result[0] = 32'hC3D2E1F0;


        for (int i = 0; i < align_string_length; i+=64) begin

            for(int j = 0; j < 16; j++) begin
                Wt[j][31:24]    = message_array[i+4*j];
                Wt[j][23:16]    = message_array[i+4*j+1];
                Wt[j][15:8]     = message_array[i+4*j+2];
                Wt[j][7:0]      = message_array[i+4*j+3];
            end

            for (int j = 16; j < 80; j++) begin
                Wt[j] = SHA1CircularShift(1,Wt[j-3] ^ Wt[j-8] ^ Wt[j-14] ^ Wt[j-16]);
            end

            A = sha1_result[4];
            B = sha1_result[3];
            C = sha1_result[2];
            D = sha1_result[1];
            E = sha1_result[0];

            for (int j = 0; j < 80; j++) begin
                temp = SHA1CircularShift(5,A) + get_Ft(j, B, C, D) + Wt[j] + E + get_Kt(j);
                E = D;
                D = C;
                C = SHA1CircularShift(30,B);
                B = A;
                A = temp;
            end

            sha1_result[4] += A;
            sha1_result[3] += B;
            sha1_result[2] += C;
            sha1_result[1] += D;
            sha1_result[0] += E;
        end

        //$display("String = %0s, sha_result = %0h", str, sha1_result);
        return sha1_result;
    endfunction


endclass //sha1_calculate