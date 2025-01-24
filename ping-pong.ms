clear

score = 0

spriteLayerIndex = 4
textLayerIndex = 3
display(spriteLayerIndex).mode = displayMode.sprite
display(spriteLayerIndex).clear
spritesOnDisplay = display(spriteLayerIndex).sprites

paddleImg = file.loadImage("/usr/Textures/Paddle.png")
ballImg = file.loadImage("/usr/Textures/Ball.png")
BGImg = file.loadImage("/usr/Textures/BG.png")
BlocksImg = []



Vector2 = {"x":0, "y":0}

PrticleSystem = {"position":Vector2_Zero, "count":0, "size":0, "speed":0, "particles":[], "directions":[]}
PrticleSystem.update = function()
	for curentIndex in range(0,self.particles.len-1)
		self.particles[curentIndex].x += self.directions[curentIndex].x * self.speed
		self.particles[curentIndex].y += self.directions[curentIndex].y * self.speed
	end for
end function

PrticleSystem.newParticleSystem = function()
	for i in range(0,self.count)
		newParticle = new Sprite
		newParticleImg = BlocksImg[rnd()*BlocksImg.len]
		newParticle.image = newParticleImg
		newParticle.scale = self.size
		newParticle.x = 0
		newParticle.y = 0
		
		newParticleDirection = new Vector2
		newParticleDirection.x = 1 - 2*rnd()
		newParticleDirection.y = 1 - 2*rnd()
		
		spritesOnDisplay.push newParticle
		self.particles.push newParticle
		self.directions.push newParticleDirection
		
	end for
end function



for i in range(1,4)
	BlocksImg.push file.loadImage("/usr/Textures/Block_"+i+".png")
end for

for x in range(0, 960, BGImg.width)
	for y in range(0, 640, BGImg.width)
		gfx.drawImage BGImg, x, y
	end for
end for


paddle = new Sprite
paddle.image = paddleImg
spritesOnDisplay.push paddle

ball = new Sprite
ball.image = ballImg
spritesOnDisplay.push ball

blocks = []
blocksScale = 4
stepBtwBlocksHorizontal = BlocksImg[0].width*blocksScale + 5
stepBtwBlocksVertical = BlocksImg[0].height*blocksScale + 5
for x in range(stepBtwBlocksHorizontal, 960- stepBtwBlocksHorizontal, stepBtwBlocksHorizontal)
	for y in range(400, 640-stepBtwBlocksVertical, stepBtwBlocksVertical)
		newBlock = new Sprite
		newBlockImg = BlocksImg[rnd()*BlocksImg.len]
		newBlock.image = newBlockImg
		newBlock.scale = blocksScale
		newBlock.x = x
		newBlock.y = y
		
		newBlock.localBounds = new Bounds
		newBlock.localBounds.width = newBlockImg.width
		newBlock.localBounds.height = newBlockImg.height
		
		spritesOnDisplay.push newBlock
		blocks.push newBlock
	end for
end for


showScore = function
	text.row = 25
	text.color = "#FFFFFF"
	print "Score:"+score
end function


paddleSpeed = 9
paddleRotation = 2
paddleScale = 2

paddle.x = 480
paddle.y = 90
paddle.scale = paddleScale
paddle.localBounds = new Bounds
paddle.localBounds.width = paddleImg.width
paddle.localBounds.height = paddleImg.height


ballDirection = new Vector2
ballDirection.x = 1 - round(rnd())*2
ballDirection.y = 1 - round(rnd())*2
ballNomalSpeed = 5
ballSpeed = ballNomalSpeed
ballScale = 2

ball.x = 480
ball.y = 220
ball.scale = ballScale
ball.localBounds = new Bounds
ball.localBounds.width = ballImg.width
ball.localBounds.height = ballImg.height

showScore

while true
	horizontalAxis = key.axis("Horizontal")
	
	if (paddle.x-paddleImg.width > 0 and horizontalAxis<0) or (paddle.x+paddleImg.width < 960 and horizontalAxis > 0) then
		paddle.x += horizontalAxis * paddleSpeed
		
		if (paddle.rotation > -2 and horizontalAxis > 0) or (paddle.rotation < 2 and horizontalAxis < 0) then
			paddle.rotation += -paddleRotation*horizontalAxis
		end if
	else
		paddle.rotation = 0
	end if
	
	if ball.y > 640 then
		ballDirection.y *= -1
		ballSpeed = ballNomalSpeed
	end if
	
	if (ball.y > 200) then
		for curentBox in blocks
			if ball.overlaps(curentBox) then
				ballSpeed = ballNomalSpeed
				
				newBlockParticleSystem = new PrticleSystem
				newBlockParticleSystem.count = 4
				newBlockParticleSystem.size = 0.2
				newBlockParticleSystem.speed = 1
				newBlockParticleSystem.newParticleSystem
				newBlockParticleSystem.update
				
				score += 1
				text.clear
				showScore
				
				if (ball.y >= curentBox.y-curentBox.image.height*blocksScale/2 or ball.y <= curentBox.y+curentBox.image.height*blocksScale/2) and ball.x <= curentBox.x+curentBox.image.width*blocksScale/2 and ball.x >= curentBox.x-curentBox.image.width*blocksScale/2 then
					ballDirection.y *= -1
				end if
				if (ball.x >= curentBox.x-curentBox.image.width*blocksScale/2 or ball.x <= curentBox.x+curentBox.image.width*blocksScale/2) and ball.y <= curentBox.y+curentBox.image.height*blocksScale/2 and ball.y >= curentBox.y-curentBox.image.height*blocksScale/2 then
					ballDirection.x *= -1
				end if
				
				spritesOnDisplay.remove spritesOnDisplay.indexOf(curentBox)
				blocks.remove blocks.indexOf(curentBox)
				break
				
			end if
		end for
	end if
	
	if ball.x > 960 or ball.x < 0 then
		ballDirection.x *= -1
	end if
	
	if paddle.overlaps(ball) and ((paddle.x-paddle.image.width*paddleScale/2 >= ball.x or paddle.x+paddle.image.width*paddleScale/2 <= ball.x) and ball.y <= paddle.y+paddle.image.height*paddleScale/2 or (ball.y > paddle.y+paddleImg.height/2)) then
		ballDirection.y *= -1
	end if
	
	ball.x += ballDirection.x * ballSpeed
	ball.y += ballDirection.y * ballSpeed
	
	if ball.y < paddle.y-paddleImg.height-10 then
		ballSpeed = 0
		clear
		showScore
		print "Game Over"
	end if
	
	yield
end while

