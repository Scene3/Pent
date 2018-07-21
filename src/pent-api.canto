/**  pent-api.fun
 *
 *   Endpoints for Pent API.
 *
 *
 **/

site pent {

    
    /---- the api ----/
    
    api {

        /** Endpoints:
         *
         *    -- view ?
         *        -- piece = name | id 
         *          -- returns a representation of the specified piece                
         *
         *        -- piece = name | id & position = n
         *          -- returns a representation of a pent board with the 
         *             specified piece at the specified position
         *             
         *        -- game = id
         *          -- returns a representation of the specified game  
         *           
         *            
         *    -- play  
         *        -- play/start
         *          -- begins a new game, returns the game id
         *
         *        -- play/choose ? game = id & a = "player name" &| b = "player name" 
         *                              &| first = a | b
         *                
         **/

        /------ view endpoints ------/

        dynamic response view(params{}) {
            if (params["position"]) {
                view_position(params);
            } else if (params["piece"]) {
                view_piece(params);
            } else if (params["game"]) {
                view_game(params);
            }
        }
        
        dynamic response view_piece(params{}) {
            piece_param = params["piece"]
            piece requested_piece = piece_table[piece_param]
           
            log("  ...requested piece: " + requested_piece.name);
            piece_serializer(requested_piece);
        }
        
        dynamic response view_position(params{}) {
            piece_param = params["piece"]
            piece requested_piece = piece_table[piece_param]
            int n = (int) params["position"]
            pent_position pos = requested_piece.all_positions[n]
            
            log("  ...requested position: " + n + " for piece: " + requested_piece.name);
            pos;
        }
        
        dynamic response view_game(params{}) {
            game_id = params["game"]
            pent_game requested_game = get_game(game_id)
            
            if (requested_game) {
                log("  ...requested game " + (game_id ? game_id : "(no id)") + " found.");
            } else {
                log("  ...requested game " + (game_id ? game_id : "(no id)") + " not found.");
            }        
        
        }

        /------ play endpoints ------/        
        
        play {
        
            dynamic response start {
                 log("Starting new game");
                 pent_game new_game = new_pent_game
                 eval(new_game);
                 log("Returning game id " + new_game.id);
                 new_game.id;
            }
        }
    }

    dynamic piece piece_from_params(params{}) {
        piece_val = params["piece"]
        int piece_id = (int) piece_val
        if (piece_id > 0) {
            piece_for_id(piece_id);
        } else {
            piece_table[piece_val];
        }
    }
}
