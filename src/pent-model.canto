/**  pent-model.fun
 *
 *   Object model for Pent.
 *
 *
 **/

site pent {


    play(piece p, int position_index) {
        keep: this piece = p
        keep: pent_position position = p.all_positions[position_index]
        this;
    }

    byte[8] pent_position = []
    
    /---- basic position tests ----/
        
    dynamic boolean is_empty(pent_position pos) = !(pos[0] | pos[1] | pos[2] | pos[3] | pos[4] | pos[5] | pos[6] | pos[7]) 
    dynamic boolean is_hit(pent_position pos1, pent_position pos2) = ((pos1[0] & pos2[0]) || (pos1[1] & pos2[1]) || (pos1[2] & pos2[2]) || (pos1[3] & pos2[3])
                                                                   || (pos1[4] & pos2[4]) || (pos1[5] & pos2[5]) || (pos1[6] & pos2[6]) || (pos1[7] & pos2[7]))

    /---- basic position masks ----/

    pent_position empty_board_mask = [ 0, 0, 0, 0, 0, 0, 0, 0 ]
    pent_position full_board_mask = [ #FF, #FF, #FF, #FF, #FF, #FF, #FF, #FF ] 

    static pent_position[64] cell_mask = [ 
        [ #80,0,0,0,0,0,0,0 ], [ #40,0,0,0,0,0,0,0 ], [ #20,0,0,0,0,0,0,0 ], [ #10,0,0,0,0,0,0,0 ], [ #08,0,0,0,0,0,0,0 ], [ #04,0,0,0,0,0,0,0 ], [ #02,0,0,0,0,0,0,0 ], [ #01,0,0,0,0,0,0,0 ],
        [ 0,#80,0,0,0,0,0,0 ], [ 0,#40,0,0,0,0,0,0 ], [ 0,#20,0,0,0,0,0,0 ], [ 0,#10,0,0,0,0,0,0 ], [ 0,#08,0,0,0,0,0,0 ], [ 0,#04,0,0,0,0,0,0 ], [ 0,#02,0,0,0,0,0,0 ], [ 0,#01,0,0,0,0,0,0 ],
        [ 0,0,#80,0,0,0,0,0 ], [ 0,0,#40,0,0,0,0,0 ], [ 0,0,#20,0,0,0,0,0 ], [ 0,0,#10,0,0,0,0,0 ], [ 0,0,#08,0,0,0,0,0 ], [ 0,0,#04,0,0,0,0,0 ], [ 0,0,#02,0,0,0,0,0 ], [ 0,0,#01,0,0,0,0,0 ],
        [ 0,0,0,#80,0,0,0,0 ], [ 0,0,0,#40,0,0,0,0 ], [ 0,0,0,#20,0,0,0,0 ], [ 0,0,0,#10,0,0,0,0 ], [ 0,0,0,#08,0,0,0,0 ], [ 0,0,0,#04,0,0,0,0 ], [ 0,0,0,#02,0,0,0,0 ], [ 0,0,0,#01,0,0,0,0 ],
        [ 0,0,0,0,#80,0,0,0 ], [ 0,0,0,0,#40,0,0,0 ], [ 0,0,0,0,#20,0,0,0 ], [ 0,0,0,0,#10,0,0,0 ], [ 0,0,0,0,#08,0,0,0 ], [ 0,0,0,0,#04,0,0,0 ], [ 0,0,0,0,#02,0,0,0 ], [ 0,0,0,0,#01,0,0,0 ],
        [ 0,0,0,0,0,#80,0,0 ], [ 0,0,0,0,0,#40,0,0 ], [ 0,0,0,0,0,#20,0,0 ], [ 0,0,0,0,0,#10,0,0 ], [ 0,0,0,0,0,#08,0,0 ], [ 0,0,0,0,0,#04,0,0 ], [ 0,0,0,0,0,#02,0,0 ], [ 0,0,0,0,0,#01,0,0 ],
        [ 0,0,0,0,0,0,#80,0 ], [ 0,0,0,0,0,0,#40,0 ], [ 0,0,0,0,0,0,#20,0 ], [ 0,0,0,0,0,0,#10,0 ], [ 0,0,0,0,0,0,#08,0 ], [ 0,0,0,0,0,0,#04,0 ], [ 0,0,0,0,0,0,#02,0 ], [ 0,0,0,0,0,0,#01,0 ], 
        [ 0,0,0,0,0,0,0,#80 ], [ 0,0,0,0,0,0,0,#40 ], [ 0,0,0,0,0,0,0,#20 ], [ 0,0,0,0,0,0,0,#10 ], [ 0,0,0,0,0,0,0,#08 ], [ 0,0,0,0,0,0,0,#04 ], [ 0,0,0,0,0,0,0,#02 ], [ 0,0,0,0,0,0,0,#01 ]
    ]
         
    
    /---- the game board ----/    

    pent_board(play[] play_list) {

        /---- the board, in various forms ----/

        keep: int[] cells = plays_to_cells(play_list)
        keep: pent_position mask = cells_to_mask 
        
        dynamic int[] rows[] = [ for int row from 0 to 8 { 
                                     [ for int col from 0 to 8 { cells[8*row + col] } ]
                                 } ]        


        /---- testers -----/
        
        dynamic boolean is_open(pent_position pos) = is_empty(pos & mask)


        /---- adapters ----/
       
        dynamic int[] plays_to_cells(play[] plays) = [
                                for int i from 0 to 64 {    
                                    (int) plays_to_cell(plays, i)
                                } ] 
        
        /** Determine if any of the piece positions in an array of plays
         *  intersect with the cell at the specified index.
         **/ 
        dynamic int plays_to_cell(play[] plays, int cell_index) {
            pent_position cell_pos = cell_mask[cell_index]
            int cell_val(int val) = val
            for play p in plays where is_hit(p.position, cell_pos) until cell_val {
                cell_val(: p.piece.id :);
            }
        }
        

        dynamic pent_position cells_to_mask = [ 
                      for int row from 0 to 8 {
                          (cells[8*row]     ? #80 : 0) | (cells[8*row + 1] ? #40 : 0) | 
                          (cells[8*row + 2] ? #20 : 0) | (cells[8*row + 3] ? #10 : 0) |
                          (cells[8*row + 4] ? #08 : 0) | (cells[8*row + 5] ? #04 : 0) |
                          (cells[8*row + 6] ? #02 : 0) | (cells[8*row + 7] ? #01 : 0)
                      }
                  ]
    }
    
    byte[8] pent_board_mask(pent_board b) = [ for int row from 0 to 8 { vals_to_mask(b.rows[row]) } ]

    
    dynamic byte vals_to_mask(int[] vals) = (vals[0] ? #80 : 0) | (vals[1] ? #40 : 0) | 
                                            (vals[2] ? #20 : 0) | (vals[3] ? #10 : 0) | 
                                            (vals[4] ? #08 : 0) | (vals[5] ? #04 : 0) | 
                                            (vals[6] ? #02 : 0) | (vals[7] ? #01 : 0)
    
    dynamic int[8] mask_to_vals(byte mask) = [ (mask & #80 ? 1 : 0), (mask & #40 ? 1 : 0),
                                               (mask & #20 ? 1 : 0), (mask & #10 ? 1 : 0),
                                               (mask & #08 ? 1 : 0), (mask & #04 ? 1 : 0),
                                               (mask & #02 ? 1 : 0), (mask & #01 ? 1 : 0) ]
    
    
    dynamic pent_position shift_down_one(pent_position pp) =  [ 0, pp[0], pp[1], pp[2], pp[3], pp[4], pp[5], pp[6] ]
    dynamic pent_position shift_right_one(pent_position pp) = [ (pp[0] >> 1), (pp[1] >> 1), (pp[2] >> 1), (pp[3] >> 1),
                                                                (pp[4] >> 1), (pp[5] >> 1), (pp[6] >> 1), (pp[7] >> 1) ]
    dynamic pent_position shift_up_one(pent_position pp) =    [ pp[1], pp[2], pp[3], pp[4], pp[5], pp[6], pp[7], 0 ]
    dynamic pent_position shift_left_one(pent_position pp) =  [ (pp[0] << 1), (pp[1] << 1), (pp[2] << 1), (pp[3] << 1),
                                                                (pp[4] << 1), (pp[5] << 1), (pp[6] << 1), (pp[7] << 1) ]

    dynamic pent_position shift_down(pent_position pp, int num_rows) = [ 
                                pp[ (8 - num_rows)  & 7 ], pp[ (9 - num_rows)  & 7 ],
                                pp[ (10 - num_rows) & 7 ], pp[ (11 - num_rows) & 7 ],
                                pp[ (12 - num_rows) & 7 ], pp[ (13 - num_rows) & 7 ],
                                pp[ (14 - num_rows) & 7 ], pp[ (15 - num_rows) & 7 ] ]

    dynamic pent_position shift_right(pent_position pp, int num_cols) = [ 
                                (pp[0] >> num_cols), (pp[1] >> num_cols),
                                (pp[2] >> num_cols), (pp[3] >> num_cols),
                                (pp[4] >> num_cols), (pp[5] >> num_cols),
                                (pp[6] >> num_cols), (pp[7] >> num_cols) ]

    dynamic pent_position shift_down_right(pent_position pp, int num_cols, int num_rows) = [ 
                                (pp[ (8 - num_rows)  & 7 ] >> num_cols), (pp[ (9 - num_rows)  & 7 ] >> num_cols),
                                (pp[ (10 - num_rows) & 7 ] >> num_cols), (pp[ (11 - num_rows) & 7 ] >> num_cols),
                                (pp[ (12 - num_rows) & 7 ] >> num_cols), (pp[ (13 - num_rows) & 7 ] >> num_cols),
                                (pp[ (14 - num_rows) & 7 ] >> num_cols), (pp[ (15 - num_rows) & 7 ] >> num_cols) ]


    piece {
        int id [?]
        name [?]
        classic_name [?]
        int value [?]
        
        int rotations [?]
        int chirality [?]
        int width [?]
        int height [?]
        
        /-- the pieces array contains all pieces in id order, starting from 1 --/
        dynamic int index_for_id(id) = (id - 1)

        pent_position[] protos = []        

        int num_positions = rotations * chirality * (9 - width) * (9 - height)

        /** the proto array includes rotations, so width and height alternate from
         *  proto to proto.  The nominal width and height apply to the 0th and
         *  subsequent even-numbered protos, while for odd-numbered protos the 
         *  width and height are swapped.
         **/   
        dynamic int width_for_proto(int n) = (n & 1 ? height : width)
        dynamic int height_for_proto(int n) = (n & 1 ? width : height)
         
        /** the all_positions array includes a mask for every possible 
         *  placement of a piece, including all rotations and flips.
         **/
        keep: pent_position[] all_positions {
            log("computing all positions for " + owner.name + "...");
            compute_all_positions;
        }

        /** for border styling purposes we have mask arrays for each cell edge
         *  (top, right, bottom, left) indicating that it is an interior 
         *  border, i.e., the border is not an outside edge of the piece.
         **/         
        pent_position[] all_top_borders {
            compute_all_top_borders;
        }
        pent_position[] all_right_borders {
            compute_all_right_borders;
        }
        pent_position[] all_bottom_borders {
            compute_all_bottom_borders;
        }
        pent_position[] all_left_borders {
            compute_all_left_borders;
        }
        
        /** functions to compute the position and border arrays **/
       
        dynamic pent_position[] compute_all_positions = [

            for pent_position p in protos and int ix from 0 {
            
                // do the first row and the first column in 
                // each row separately to avoid a call

                /---- row 0, col 0 ----/
                p, 
                
                /---- row 0, col 1 ----/
                shift_right_one(p),

                /---- row 0, cols 2-7 ----/
                for int num_cols from 2 to (9 - width_for_proto(ix)) {
                    shift_right(p, num_cols),
                },

                /---- rows 1-7 ----/                                  
                for int num_rows from 1 to (9 - height_for_proto(ix)) {

                    /---- col 0 ----/
                    shift_down(p, num_rows),
                     
                    /---- cols 1-7 ----/
                    for int num_cols from 1 to (9 - width_for_proto(ix)) {
                        shift_down_right(p, num_cols, num_rows),
                    }
                }
            }
        ]

        dynamic pent_position[] compute_all_top_borders = [
            // a cell has a top border if its mask bit is true and the
            // corresponding mask bit in the row above is true
            for pent_position p in all_positions {
                (p & shift_down_one(p)),
            }
        ]

        dynamic pent_position[] compute_all_right_borders = [
            // a cell has a right border if its mask bit is true and the
            // corresponding mask bit in the column to the right is true
            for pent_position p in all_positions {
                (p & shift_left_one(p)),
            }
        ]

        dynamic pent_position[] compute_all_bottom_borders = [
            // a cell has a bottom border if its mask bit is true and the
            // corresponding mask bit in the row below is true
            for pent_position p in all_positions {
                (p & shift_up_one(p)),
            }
        ]

        dynamic pent_position[] compute_all_left_borders = [
            // a cell has a left border if its mask bit is true and the
            // corresponding mask bit in the column to the left is true
            for pent_position p in all_positions {
                (p & shift_right_one(p)),
            }
        ]

        /-- instantiate as object --/
        this;                                      
    }



    
    dynamic piece piece_for_id(int id) {
        if (id >= 1 && id <= 12) {
            pieces[id - 1];
        }
    }

    /---- serializer ----/
    
    dynamic serializable(str), piece piece_serializer(str), (piece p) {
        keep: int id        = p.id
        keep: pent_position[] all_positions = p.all_positions
        keep: name          = p.name
        keep: classic_name  = p.classic_name
        keep: int value     = p.value
        keep: int rotations = p.rotations
        keep: int chirality = p.chirality
        keep: int width     = p.width
        keep: int height    = p.height
        keep: pent_position[] protos = p.protos

        with (p) {
            serialize;
        } else {
            this;
        }
    }
    

    /** the twelve pentomino pieces **/

    global piece[12] pieces = [
        utah,
        faucet,
        long_L,
        snake,
        pipe,
        C_piece,
        square_L,
        T_piece,
        stairs,
        zigzag,
        bar,
        plus
    ]
    
    global piece{} piece_table = { for piece p in pieces { p.id: p, p.name: p, to_lower(p.name): p, to_upper(p.name): p } }

    static int UTAH_ID = 1
    static int FAUCET_ID = 2
    static int LONG_L_ID = 3
    static int SNAKE_ID = 4
    static int PIPE_ID = 5
    static int C_PIECE_ID = 6
    static int SQUARE_L_ID = 7
    static int T_PIECE_ID = 8
    static int STAIRS_ID = 9
    static int ZIGZAG_ID = 10
    static int BAR_ID = 11
    static int PLUS_ID = 12

    
    global piece utah {
        int id = UTAH_ID
        name = "Utah"
        classic_name = "P"
        int value = 10

        int rotations = 4
        int chirality = 2
        int width = 2
        int height = 3
        
        pent_position[] protos = [ [ #80, #C0, #C0, 0, 0, 0, 0, 0 ],
                                   [ #E0, #C0,   0, 0, 0, 0, 0, 0 ],
                                   [ #C0, #C0, #40, 0, 0, 0, 0, 0 ],
                                   [ #60, #E0,   0, 0, 0, 0, 0, 0 ],

                                   [ #40, #C0, #C0, 0, 0, 0, 0, 0 ],
                                   [ #C0, #E0,   0, 0, 0, 0, 0, 0 ],
                                   [ #C0, #C0, #80, 0, 0, 0, 0, 0 ],
                                   [ #E0, #60,   0, 0, 0, 0, 0, 0 ] ]
    }
    
    global piece faucet {
        int id = FAUCET_ID
        name = "Faucet"
        classic_name = "F"
        int value = 9

        int rotations = 4
        int chirality = 2
        int width = 3
        int height = 3
        
        pent_position[] protos = [ [ #40, #E0, #20, 0, 0, 0, 0, 0 ],
                                   [ #40, #60, #C0, 0, 0, 0, 0, 0 ],
                                   [ #80, #E0, #40, 0, 0, 0, 0, 0 ],
                                   [ #60, #C0, #40, 0, 0, 0, 0, 0 ],

                                   [ #40, #E0, #80, 0, 0, 0, 0, 0 ],
                                   [ #C0, #60, #40, 0, 0, 0, 0, 0 ],
                                   [ #20, #E0, #40, 0, 0, 0, 0, 0 ],
                                   [ #40, #C0, #60, 0, 0, 0, 0, 0 ] ]
    }
        
    global piece long_L {
        int id = LONG_L_ID
        name = "Long L"
        classic_name = "L"
        int value = 8

        int rotations = 4
        int chirality = 2
        int width = 2
        int height = 4
        
        pent_position[] protos = [ [ #80, #80, #80, #C0, 0, 0, 0, 0 ],
                                   [ #F0, #80,   0,   0, 0, 0, 0, 0 ],
                                   [ #C0, #40, #40, #40, 0, 0, 0, 0 ],
                                   [ #10, #F0,   0,   0, 0, 0, 0, 0 ],

                                   [ #40, #40, #40, #C0, 0, 0, 0, 0 ],
                                   [ #80, #F0,   0,   0, 0, 0, 0, 0 ],
                                   [ #C0, #80, #80, #80, 0, 0, 0, 0 ],
                                   [ #F0, #10,   0,   0, 0, 0, 0, 0 ] ]
    }
        
    global piece snake {
        int id = SNAKE_ID
        name = "Snake"
        classic_name = "N"
        int value = 8

        int rotations = 4
        int chirality = 2
        int width = 2
        int height = 4
        
        pent_position[] protos = [ [ #80, #80, #C0, #40, 0, 0, 0, 0 ],
                                   [ #70, #C0,   0,   0, 0, 0, 0, 0 ],
                                   [ #80, #C0, #40, #40, 0, 0, 0, 0 ],
                                   [ #30, #E0,   0,   0, 0, 0, 0, 0 ],

                                   [ #40, #40, #C0, #80, 0, 0, 0, 0 ],
                                   [ #C0, #70,   0,   0, 0, 0, 0, 0 ],
                                   [ #40, #C0, #80, #80, 0, 0, 0, 0 ],
                                   [ #E0, #30,   0,   0, 0, 0, 0, 0 ] ]
    }
       
    global piece pipe {
        int id = PIPE_ID
        name = "Pipe"
        classic_name = "Y"
        int value = 8

        int rotations = 4
        int chirality = 2
        int width = 2
        int height = 4
        
        pent_position[] protos = [ [ #80, #80, #C0, #80, 0, 0, 0, 0 ],
                                   [ #F0, #40,   0,   0, 0, 0, 0, 0 ],
                                   [ #40, #C0, #40, #40, 0, 0, 0, 0 ],
                                   [ #20, #F0,   0,   0, 0, 0, 0, 0 ],

                                   [ #40, #40, #C0, #40, 0, 0, 0, 0 ],
                                   [ #40, #F0,   0,   0, 0, 0, 0, 0 ],
                                   [ #80, #C0, #80, #80, 0, 0, 0, 0 ],
                                   [ #F0, #20,   0,   0, 0, 0, 0, 0 ] ]
    }
       
    
    global piece C_piece {
        int id = C_PIECE_ID
        name = "C"
        classic_name = "U"
        int value = 5
        
        int rotations = 4
        int chirality = 1
        int width = 2
        int height = 3
        
        pent_position[] protos = [ [ #C0, #80, #C0, 0, 0, 0, 0, 0 ],
                                   [ #E0, #A0,   0, 0, 0, 0, 0, 0 ],
                                   [ #C0, #40, #C0, 0, 0, 0, 0, 0 ],
                                   [ #A0, #E0,   0, 0, 0, 0, 0, 0 ] ]
    }
        

    global piece square_L {
        int id = SQUARE_L_ID
        name = "Square L"
        classic_name = "V"
        int value = 4

        int rotations = 4
        int chirality = 1
        int width = 3
        int height = 3
        
        pent_position[] protos = [ [ #80, #80, #E0, 0, 0, 0, 0, 0 ],
                                   [ #E0, #80, #80, 0, 0, 0, 0, 0 ],
                                   [ #E0, #20, #20, 0, 0, 0, 0, 0 ],
                                   [ #20, #20, #E0, 0, 0, 0, 0, 0 ] ]
    }        

    global piece T_piece {
        int id = T_PIECE_ID
        name = "T"
        classic_name = "T"
        int value = 4

        int rotations = 4
        int chirality = 1
        int width = 3
        int height = 3
        
        pent_position[] protos = [ [ #E0, #40, #40, 0, 0, 0, 0, 0 ],
                                   [ #20, #E0, #20, 0, 0, 0, 0, 0 ],
                                   [ #40, #40, #E0, 0, 0, 0, 0, 0 ],
                                   [ #80, #E0, #80, 0, 0, 0, 0, 0 ] ]
    }
        
    global piece stairs {
        int id = STAIRS_ID
        name = "Stairs"
        classic_name = "W"
        int value = 4

        int rotations = 4
        int chirality = 1
        int width = 3
        int height = 3
        
        pent_position[] protos = [ [ #80, #C0, #60, 0, 0, 0, 0, 0 ],
                                   [ #60, #C0, #80, 0, 0, 0, 0, 0 ],
                                   [ #C0, #60, #20, 0, 0, 0, 0, 0 ],
                                   [ #20, #60, #C0, 0, 0, 0, 0, 0 ] ]
    }
        
    global piece zigzag {
        int id = ZIGZAG_ID
        name = "Zigzag"
        classic_name = "Z"
        int value = 4

        int rotations = 2
        int chirality = 2
        int width = 3
        int height = 3
        
        pent_position[] protos = [ [ #C0, #40, #60, 0, 0, 0, 0, 0 ],
                                   [ #20, #E0, #80, 0, 0, 0, 0, 0 ],

                                   [ #60, #40, #C0, 0, 0, 0, 0, 0 ],
                                   [ #80, #E0, #20, 0, 0, 0, 0, 0 ] ]
    }
      
    global piece bar {
        int id = BAR_ID
        name = "Bar"
        classic_name = "I"
        int value = 2

        int rotations = 2
        int chirality = 1
        int width = 1
        int height = 5
        
        pent_position[] protos = [ [ #80, #80, #80, #80, #80, 0, 0, 0 ],
                                   [ #F8,   0,   0,   0,   0, 0, 0, 0 ] ]
    }
        
    global piece plus {
        int id = PLUS_ID
        name = "Plus"
        classic_name = "X"
        int value = 1

        int rotations = 1
        int chirality = 1
        int width = 3
        int height = 3
        
        pent_position[] protos = [ [ #40, #E0, #40, 0, 0, 0, 0, 0 ] ]
    }

}
