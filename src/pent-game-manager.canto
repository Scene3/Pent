/**  pent-game-manager.fun
 *
 *   Game manager for Pent.
 *
 *
 **/

site pent {

    /--------- game persistence ---------/
    
    global pent_game{} game_repository = {}
    
    dynamic save_game(pent_game pg) {
        pg_id = pg.id
        keep by pg_id in game_repository: pent_game persisted_game = pg
        
        eval(persisted_game);
    }

    dynamic pent_game get_game(id) {
        game_repository[id];
    }


    /--------- new game creation ---------/
    
    global long global_id_sequence(int n) = n
    dynamic long next_id_sequence = global_id_sequence(: global_id_sequence + 1 :)

    dynamic pent_game new_pent_game {
        new_game_id = generate_game_id(next_id_sequence)
        pent_game(new_game_id) new_game [/]
        
        log("Creating new game, id = " + new_game_id);
        save_game(new_game);
        new_game;
    }


    /--------- id generation ---------/

    dynamic generate_game_id(long seq) {
        rsec67(seq % 300763);   // 67 * 67 * 67    
    }
    
    dynamic rsec67(long n) {

        long id_val = n
        
        dynamic to67(long val) {
            int val_mod = val % 67
            long next_val = val / 67

            char next_c = (char) (val_mod >= 40 ? (val_mod + 24) :
                                  val_mod == 39 ? (val_mod + 6) :
                                  val_mod == 38 ? (val_mod + 5) :
                                  val_mod >= 28 ? (val_mod + 20) :
                                  val_mod > 1 ? (val_mod + 95) :
                                  val_mod == 1 ? '$' : '*')
                                  
            sub;
        }
        
        dynamic to67(val) forward67(long val) {
            if (next_val) {
                forward67(next_val);
            }
            next_c;
        }

        dynamic to67(val) rev67(long val) {
            next_c;
            if (next_val) {
                rev67(next_val);
            }
        }

        rev67(current_seconds);
        if (id_val < 67)        { "**"; }
        else if (id_val < 4489) { "*"; }
        forward67(id_val);
    }


}
