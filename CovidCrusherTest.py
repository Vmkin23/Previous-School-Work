import pygame
import os
pygame.font.init()
#pygame.mixer.init()

WIDTH, HEIGHT = 900, 500
WIN = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Covid Crusher!")

WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
RED = (255, 0, 0)
YELLOW = (255, 255, 0)

BORDER = pygame.Rect(WIDTH//2 -5, 0, 10, HEIGHT)

#BULLET_HIT_SOUND = pygame.mixer.Sound(os.path.join('Covid Crusher', 'sound.mp3'))
#BULLET_FIRE_SOUND = pygame.mixer.Sound(os.path.join('Covid Crusher', 'sound2.mp3'))

HEALTH_FONT = pygame.font.SysFont('comicsans', 40)
WINNER_FONT = pygame.font.SysFont('comicsans', 100)

FPS = 60
VEL = 5
BULLET_VEL = 7
MAX_BULLETS = 10
PCNPC_WIDTH, PCNPC_HEIGHT = 60, 60

PC_HIT = pygame.USEREVENT + 1
NPC_HIT = pygame.USEREVENT + 2

POWERUP_IMAGE = pygame.image.load(os.path.join('Covid Crusher', 'POWER.png'))
POWERUP = pygame.transform.scale(POWERUP_IMAGE, (45,30))

GERMS_IMAGE = pygame.image.load(os.path.join('Covid Crusher', 'GERM.png'))
GERMS = pygame.transform.scale(GERMS_IMAGE, (PCNPC_WIDTH, PCNPC_HEIGHT))

PERSON_IMAGE = pygame.image.load(os.path.join('Covid Crusher', 'PERSON.png'))
PERSON = pygame.transform.scale(PERSON_IMAGE, (PCNPC_WIDTH, PCNPC_HEIGHT))

SCHOOL = pygame.transform.scale(pygame.image.load(os.path.join('Covid Crusher', 'SCHOOL.png')), (WIDTH, HEIGHT))

def draw_window(PC, NPC, PC_bullets, NPC_bullets, PC_health, NPC_health):
        WIN.blit(SCHOOL, (0, 0))
        pygame.draw.rect(WIN, BLACK, BORDER)
        
        PC_health_text = HEALTH_FONT.render("Health: " + str(NPC_health), 1, WHITE)
        NPC_health_text = HEALTH_FONT.render("Health: " + str(PC_health), 1, WHITE)
        WIN.blit(PC_health_text, (WIDTH - PC_health_text.get_width() - 10, 10))
        WIN.blit(NPC_health_text, (10, 10))
        
        WIN.blit(GERMS, (NPC.x, NPC.y))
        WIN.blit(PERSON, (PC.x, PC.y))
        WIN.blit(POWERUP, (100,200))
        
        
        
        for bullet in PC_bullets:
                pygame.draw.rect(WIN, YELLOW, bullet)
        for bullet in NPC_bullets:
                pygame.draw.rect(WIN, RED, bullet)
                
        pygame.display.update()    

def PC_movement(keys_pressed, PC):
        if keys_pressed[pygame.K_a] and PC.x - VEL > 0: #:LEFT
                PC.x -= VEL
        if keys_pressed[pygame.K_d] and PC.x + VEL + PC.width < BORDER.x: #:RIGHT
                PC.x += VEL
        if keys_pressed[pygame.K_w] and PC.y - VEL > 0: #:UP
                PC.y -= VEL
        if keys_pressed[pygame.K_s] and PC.y + VEL + PC.height < HEIGHT: #:DOWN
                PC.y += VEL  

def NPC_movement(keys_pressed, NPC):
        if keys_pressed[pygame.K_LEFT] and NPC.x - VEL > BORDER.x + BORDER.width: #:LEFT
                NPC.x -= VEL
        if keys_pressed[pygame.K_RIGHT] and NPC.x + VEL + NPC.width < WIDTH: #:RIGHT
                NPC.x += VEL
        if keys_pressed[pygame.K_UP] and NPC.y - VEL > 0: #:UP
                NPC.y -= VEL
        if keys_pressed[pygame.K_DOWN] and NPC.y + VEL + NPC.height < HEIGHT: #:DOWN
                NPC.y += VEL 

def handle_bullets(PC_bullets, NPC_bullets, PC, NPC):
        for bullet in PC_bullets:
                bullet.x += BULLET_VEL
                if NPC.colliderect(bullet):
                        pygame.event.post(pygame.event.Event(NPC_HIT))
                        PC_bullets.remove(bullet)
                elif bullet.x > WIDTH:
                        PC_bullets.remove(bullet)
                        
        for bullet in NPC_bullets:
                bullet.x -= BULLET_VEL
                if PC.colliderect(bullet):
                        pygame.event.post(pygame.event.Event(PC_HIT))
                        NPC_bullets.remove(bullet)
                elif bullet.x < 0:
                        NPC_bullets.remove(bullet)

def draw_winner(text):
        draw_text = WINNER_FONT.render(text, 1, WHITE)
        WIN.blit(draw_text, (WIDTH//2 - draw_text.get_width()//2, HEIGHT/2 - draw_text.get_height()//2))
        pygame.display.update()
        pygame.time.delay(5000)

def main():
        PC = pygame.Rect(100, 300, PCNPC_WIDTH, PCNPC_HEIGHT)
        NPC = pygame.Rect(500, 300, PCNPC_WIDTH, PCNPC_HEIGHT)
        
        PC_bullets = []
        NPC_bullets = []
        
        PC_health = 6
        NPC_health = 6
        
        clock = pygame.time.Clock()
        run = True
        while run:
                clock.tick(FPS)
                for event in pygame.event.get():
                        if event.type == pygame.QUIT:
                                run = False
                                pygame.quit()
                                
                        if event.type == pygame.KEYDOWN:
                                if event.key == pygame.K_LCTRL and len(NPC_bullets) < MAX_BULLETS:
                                        bullet = pygame.Rect(PC.x + PC.width, PC.y + PC.height//2 - 2, 10, 5)
                                        PC_bullets.append(bullet)
                                        #BULLET_FIRE_SOUND.play()
                                
                                if event.key == pygame.K_RCTRL and len(PC_bullets) < MAX_BULLETS:
                                        bullet = pygame.Rect(NPC.x, NPC.y + NPC.height//2 - 2, 10, 5)
                                        NPC_bullets.append(bullet)
                                        #BULLET_FIRE_SOUND.play()
                                        
                        if event.type == PC_HIT:
                                PC_health -= 1
                                #BULLET_HIT_SOUND.play()
                        if event.type == NPC_HIT:
                                NPC_health -= 1
                                #BULLET_HIT_SOUND.play()
                                
                winner_text = ""
                if NPC_health <= 0:
                        winner_text = "You win!"
                if PC_health <= 0:
                        winner_text = "Germs win!"
                
                if winner_text != "":
                        draw_winner(winner_text)
                        break
                     
                keys_pressed = pygame.key.get_pressed()
                PC_movement(keys_pressed, PC)
                NPC_movement(keys_pressed, NPC)
                
                handle_bullets(PC_bullets, NPC_bullets, PC, NPC)
                                   
                draw_window(PC, NPC, PC_bullets, NPC_bullets, PC_health, NPC_health)
        
        main()
    
    
if __name__ == "__main__":
        main()