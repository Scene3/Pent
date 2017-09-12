/**  pent-view.fun
 *
 *   View components for Pent.
 *
 *
 **/

site pent {

    /---- site-level view options ----/
    
    static int STANDARD_MODE = 0
    static int TEXT_MODE = 1
    static int TWO_MODE = 2
    static int THREE_MODE = 3

    int view_mode(int mode) = mode 
    int display_mode(int mode) = mode 


    /---- piece attributes ----/
    
    
    /---- view css ----/
    
    pent_view_style [/

        .view {
            margin: auto;
            width: auto;
            box-sizing: border-box;
        }
    
        .view div {
            box-sizing: border-box;
        }
    
        .pent_board td {
            border-width: 0;
            padding: 0;
            text-align: center;
        }
    
        .pent_board {
            margin: 4rem;
            table-layout: fixed;
            border-style: outset;
            border-width: 0.5rem;
            border-spacing: 0;
            border-collapse: false;
            color: #EEEE00;
            background-color: #111122;
        }    

        .pent_tile {
            border-width: 0.125rem;
            width: 1.25rem;
            height: 1.25rem;
            padding: 0.5rem;
            color: #777777;
            background-color: #070707;
        }
 
        .empty_cell {
            border-style: inset;
            border-color: #444444;
        }

        .filled_cell {
            border-style: outset;
        }
        
        .title_bar {
            width: 100%;
            padding: 0.5rem;
            color: #7C7C7C;
            text-align: center;
            font-weight: bold;
            font-size: .95rem;
            font-family: "Arial Black","Arial Bold",sans-serif;
            box-sizing: border-box;
            z-index: 200;
        }
        
        .pent_letter {
            display: inline;
            padding: 0 2em;
        }
        
        .canvas_spacer {
            width: 64rem;
            height: 20rem;
            margin: auto;
        }
    /]


    /---- the main component ----/

    dynamic pent_view console_view(pent_game gm, params{}) {
        title_view;
        console_script(gm);
        pent_console(gm, params);
        if (display_mode == THREE_MODE) {
            three_scene_viewer(gm);
        } else if (display_mode == TWO_MODE) {
            two_scene_viewer(gm);
        } else {
            log("unknown display mode: " + display_mode);      
        }
    }


    /---- view components ----/

    dynamic pent_tile(int value), (int value, boolean top, boolean right, boolean bottom, boolean left) {  
        [/ <div class="pent_tile {= (value ? "filled_cell" : "empty_cell"); =}" |]

        if (view_mode == STANDARD_MODE) {
            if (value) [/ 
                style="background-color: {= color_for_piece(value); =}; border-color: {= border_color_for_piece(value); =}"
            /]
        }

        [/ > /]        
        
        if (view_mode == TEXT_MODE) { 
            value;
        }

        [/ </div> /]
    }
        
    dynamic color_for_piece(int id) {
        piece_color[id - 1];
    }    

    dynamic border_color_for_piece(int id) {
        piece_border_color[id - 1];
    }    

    piece_color[12] = [ "#DD4444",
                        "#44DD44",
                        "#4444DD",
                        "#AAAA22",
                        "#AA22AA",
                        "#22AAAA",
                        "#CC6611",
                        "#11CC66",
                        "#6611CC",
                        "#66CC11",
                        "#1166CC",
                        "#CC1166" ]

    piece_border_color[12] = [ "#FF6666",
                               "#66FF66",
                               "#6666FF",
                               "#CCCC44",
                               "#CC44CC",
                               "#44CCCC",
                               "#EE8833",
                               "#33EE88",
                               "#8833EE",
                               "#88EE33",
                               "#3388EE",
                               "#EE3388" ]


    dynamic component pent_view {
        component_class = "view " + owner.type
        
        int x [?]
        int y [?]
    }

    dynamic pent_view team_view(team_name, pent_team team, pent_team_played played) {
        if (view_mode == TEXT_MODE) {
            
        
        } else {
        
        
        }    
     }
    
    dynamic pent_view set_view(piece[] removed) {
    
    }
    
    component title_view {
        component_class = "title_bar"
        
        component pent_letter {
            component_class = "pent_letter"
        }
        
        pent_letter pent_p [/ P /]
        pent_letter pent_e [/ E /]
        pent_letter pent_n [/ N /]
        pent_letter pent_t [/ T /]
        
        pent_p;
        pent_e;
        pent_n;
        pent_t;
    }
    
    
    dynamic pent_view board_view(pent_game game) {
    
        pent_board board = pent_board(game.plays)
        int[] cells = board.cells

        [/ <table class="pent_board"> /]
        for int row = 0 to 8 {
            [/ <tr> /]
            for int col = 0 to 8 {
                [/ <td> /]
                pent_tile(cells[row * 8 + col]);
                [/ </td> /]
            }
            [/ </tr> /]
        }
        [/ </table> /]
    }

    dynamic pent_view piece_view(piece p), (piece p, int pos_index) {
        pent_position pos = p.all_positions[pos_index]

        pent_position top_border = p.all_top_borders[pos_index]
        pent_position right_border = p.all_right_borders[pos_index]
        pent_position bottom_border = p.all_bottom_borders[pos_index]
        pent_position left_border = p.all_left_borders[pos_index]

        int piece_id = p.id

        dynamic handle_cell(int cell_index) {
            pent_position mask = cell_mask[cell_index]
            dynamic boolean is_hit(pent_position p) = pent_board.is_hit(p, mask)
        
            if (is_hit(pos)) {
                pent_tile(piece_id, is_hit(top_border), is_hit(right_border), is_hit(bottom_border), is_hit(left_border));
            } else {
                pent_tile(0);
            }
        }        
        
        [/ <table class="pent_board"> /]
        for int row = 0 to 8 {
            [/ <tr> /]
            for int col = 0 to 8 {
                [/ <td> /]
                handle_cell(row * 8 + col);
                [/ </td> /]
            }
            [/ </tr> /]
        }
        [/ </table> /]
    }

}
