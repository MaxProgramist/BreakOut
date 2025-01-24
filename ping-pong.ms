clear

Vector2 = {"x":0, "y":0}


FPS = 1/60
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


paddleSpeed = 9
paddleRotation = 2
paddleScale = 2

paddle.x = 480
paddle.y = 160
paddle.scale = paddleScale
paddle.localBounds = new Bounds
paddle.localBounds.width = paddleImg.width
paddle.localBounds.height = paddleImg.height


ballDirection = new Vector2
ballDirection.x = 1 - round(rnd())*2
ballDirection.y = 1 - round(rnd())*2
ballSpeed = 5
ballScale = 2

ball.x = 480
ball.y = 220
ball.scale = ballScale
ball.localBounds = new Bounds
ball.localBounds.width = ballImg.width
ball.localBounds.height = ballImg.height

while true
	textDisplay.clear
	textDisplay.row = 25
	
	if (paddle.x-paddleImg.width > 0 and key.axis("Horizontal")<0) or (paddle.x+paddleImg.width < 960 and key.axis("Horizontal")>0) then
		paddle.x += key.axis("Horizontal") * paddleSpeed
		
		if (paddle.rotation > -2 and key.axis("Horizontal") > 0) or (paddle.rotation < 2 and key.axis("Horizontal") < 0) then
			paddle.rotation += -paddleRotation*key.axis("Horizontal")
		end if
	else
		paddle.rotation = 0
	end if
	
	if ball.y > 640 then
		ballDirection.y *= -1
	end if
	
	if paddle.overlaps(ball) and ball.y > paddle.y+paddleImg.height/2 then
		ballDirection.y *= -1
	end if
	
	if (ball.y > 200) then
		for curentBox in blocks
			if sqrt((curentBox.x-ball.x)^2 + (curentBox.y-ball.y)^2)<10 then
				continue
			end if
			if ball.overlaps(curentBox) then
				score += 1
				
				if ball.y > curentBox.y+curentBox.image.height or ball.y < curentBox.y-curentBox.image.height then
					ballDirection.y *= -1
				end if
				if  ball.x > curentBox.x+curentBox.image.width or ball.x < curentBox.x-curentBox.image.width then
					ballDirection.x *= -1
				end if
				
				spritesOnDisplay.remove spritesOnDisplay.indexOf(curentBox)
				
			end if
		end for
	end if
	
	if ball.x > 960 or ball.x < 0 or (paddle.overlaps(ball) and (paddle.x > ball.x or paddle.x < ball.x) and ball.y < paddle.y+paddleImg.height/2) then
		ballDirection.x *= -1
	end if
	
	ball.x += ballDirection.x * ballSpeed
	ball.y += ballDirection.y * ballSpeed
	
	if ball.y < paddle.y-paddleImg.height-10 then
		ballSpeed = 0
		clear
		print "Game Over"
	end if
	
	textDisplay.color = "#FFFFFF"
	print "Score:"+score
	
	yield
end while

