from twisted.internet import reactor
import cocos
from pyglet.window import key

class GameLayer(cocos.layer.Layer):
    
    def __init__(self):
        super(GameLayer, self).__init__()
        sprite = cocos.sprite.Sprite("arena.png")
        sprite.position = 240, 160
        self.add(sprite)

class InterfaceLayer(cocos.layer.Layer):    
    is_event_handler = True
    
    def __init__(self):
        super(InterfaceLayer, self).__init__()
                
        label = cocos.text.Label('test',
            font_name='Arial',
            font_size = 16,
            anchor_x = 'center', anchor_y = 'center')
        label.position = 240, 160
        
        label.do(cocos.actions.Repeat(
                cocos.actions.Sequence(cocos.actions.FadeOut(0.5), cocos.actions.FadeIn(0.5))
                ))
        self.add(label)
        
        backmenu = cocos.sprite.Sprite("back.png")
        backmenu.position = 240, 160
        backmenu.opacity = 100
        backmenu.position = backmenu.width / 2 + 4, backmenu.height / 2 + 4
        self.add(backmenu)
        #[backmenu setVisible:NO];
    
    def on_key_release(self, keys, mod):
        if keys == key.LEFT:
            print "left"
        elif keys == key.RIGHT:
            print "right"
        elif keys == key.UP:
            print "up"
        elif keys == key.DOWN:
            print "down"


def initGUI():
    cocos.director.director.init(480, 320)
    
    glayer = GameLayer()
    mlayer = InterfaceLayer()
    
    main_scene = cocos.scene.Scene()
    main_scene.add(glayer, z = 0)
    main_scene.add(mlayer, z = 1)
    
    cocos.director.director.run(main_scene)
    if reactor.running:
        reactor.stop()


if __name__ == "__main__":
    initGUI()
