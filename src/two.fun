/**  two.fun
 *
 *   Support for Canvas 2D graphics
 *
 *
 **/

site two {


    /---- 2D graphics objects ----/
    
    draw_type [?]
    static draw_type CLEAR = "clear"
    static draw_type FILL = "fill"
    static draw_type STROKE = "stroke"
    
    dynamic rect_args(rect r) = r.x1 + "," + r.y1 + "," + r.width + "," + r.height
        
    
    two_context(context_name) {
    
        keep: name = context_name
    
        /-- base rectangle function.  draw_type can be clear, fill or stroke --/
        dynamic draw_rect(draw_type, rect r) {
            context_name;
            [/ . /]
            draw_type;
            [/ Rect( /]
            rect_args(r);
            [/ ); /]
        }
    
    
    }

    /** Base class of objects used in scene construction.
      * 
      **/

    dynamic two_object {
        decl [/]
        args[] = []
        options{} = {}
        keep: position pos(position p) = p
        keep: rotation rot(rotation r) = r

        two_object[] objs = []
        boolean is_composite = (objs.count > 1)
        
        /-- optional event handlers --/

        on_point_to [?]
        on_hover_over [?]
        on_drag [?]
        
        /-- check for defined handlers --/

        dynamic boolean is_pointable = on_point_to ?? true : false
        dynamic boolean is_hoverable = on_hover_over ?? true : false
        dynamic boolean is_draggable = on_drag ?? true : false

        two_object[] pointable_objs = [
                if (owner.owner.is_pointable) {
                    owner.owner.def
                } else {
                    for two_object o in objs {
                        for two_object po in o.pointable_objs {
                            po.def
                        }
                    }
                }
            ]

        two_object[] hoverable_objs = [
                if (owner.owner.is_hoverable) {
                    owner.owner.def
                } else {
                    for two_object o in objs {
                        for two_object ho in o.hoverable_objs {
                            ho.def
                        }
                    }
                }
            ]

        two_object[] draggable_objs = [
                if (owner.owner.is_draggable) {
                    owner.owner.def
                } else {
                    for two_object o in objs {
                        for two_object dro in o.draggable_objs {
                            dro.def
                        }
                    }
                }
            ]


        
        /-- animation logic, called for each frame --/

        next_frame [?]

        
        dynamic rotate(float x, float y) {
            newline;
            name; [/ .rotation.x += {= x; =}; /]
            name; [/ .rotation.y += {= y; =}; /]
        }
        
        dynamic orient(float x, float y) {
            newline;
            name; [/ .rotation.x = {= x; =}; /]
            name; [/ .rotation.y = {= y; =}; /]
        }
        
        dynamic rotate_on_axis(vector3 axis, float angle) {
            newline;
            name; [/ .rotateOnAxis({= axis; =},{= angle; =}); /]
        }

        dynamic move(float x, float y) {
            newline;
            name; [/ .position.x += {= x; =}; /]
            name; [/ .position.y += {= y; =}; /]
        }

        dynamic locate(float x, float y) {
            newline;
            name; [/ .position.x = {= x; =}; /]
            name; [/ .position.y = {= y; =}; /]
        }

        dynamic immutable_field(pos.x, pos.y) set_position {
            name = "position"
        }

        dynamic immutable_field(rot.x, rot.y) set_rotation {
            name = "rotation"
        }

        dynamic draw(two_context ctx) {
            set_transform(ctx);
            sub;
            for two_object obj in objs {
                obj.draw(ctx);
            }
        }
        
        this;
    }


    /---- viewer for 2D graphics ----/ 

    dynamic component canvas_viewer {
        width = "100%"
        height = "100%" 
        

            
    }

}
