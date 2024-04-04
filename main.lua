-- PONG

function resetBall()
  
	ball.x, ball.y = window.width/2-ball.size/2, love.math.random(0, window.height-ball.size)
	
	ball.xDir, ball.yDir = love.math.random(0,1), love.math.random(0,1)
	
	if ball.xDir == 1 then ball.xSpeed = -ball.xSpeed end
	if ball.yDir == 1 then ball.ySpeed = -ball.ySpeed end
	
	ball.timer = startPause

end

function drawNet()
	
	netLineLen = 24
	for y=0, window.height, netLineLen*2 do love.graphics.line(window.width/2, y, window.width/2, y+netLineLen) end

end

function movePlayer()
  
	if (love.keyboard.isDown("up") or love.keyboard.isDown("w")) and player.y >= 0 then
		player.y = player.y - gameSpeed
	end
	
	if (love.keyboard.isDown("down") or love.keyboard.isDown("s")) and player.y+player.height <= window.height then
		player.y = player.y + gameSpeed
	end

end

function moveBot()
	
	if ball.timer < 0 then
	
		if bot.y+bot.height/2 < ball.y and bot.y+bot.height < window.height then
			bot.y = bot.y + gameSpeed
		end
	
		if bot.y+bot.height/2 > ball.y and bot.y > 0 then
			bot.y = bot.y - gameSpeed
		end
	
	end

end

function moveBall()

  ball.timer = ball.timer - 1

  if ball.timer < 0 then

    ball.x = ball.x + ball.xSpeed
    ball.y = ball.y + ball.ySpeed

    if ball.x >= player.x and ball.x <= player.x+player.width and ball.y >= player.y and ball.y <= player.y+player.height and ball.xSpeed < 0 then
      ball.xSpeed = -ball.xSpeed
    end

    if ball.x+ball.size >= bot.x and ball.x+ball.size <= bot.x+bot.width and ball.y >= bot.y and ball.y <= bot.y+bot.height and ball.xSpeed > 0 then
      ball.xSpeed = -ball.xSpeed
    end

    if ball.y <= 0 or ball.y >= window.height-ball.size then
      ball.ySpeed = -ball.ySpeed
    end

    if ball.x+ball.size < 0 then
      bot.score = bot.score + 1
      resetBall()
    end

    if ball.x > window.width then
      player.score = player.score + 1
      resetBall()
    end

  end

end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function love.load()

	gameSpeed = 4

	window = {width=600, height=600}
	love.window.setMode(window.width, window.height)
	love.window.setTitle("pong")

	font = love.graphics.newFont("pong-score.ttf", 72)
	love.graphics.setFont(font)

	player = {x=20, width=10, height=40, score=0}
	player.y = window.height/2-player.height/2

	bot = {width=10, height=40, score=0}
	bot.x, bot.y = window.width-20-bot.width, window.height/2-bot.height/2

	startPause = 2*60

	ball = {
		x=window.width,
		y=window.height,
		size=10,
		xSpeed=gameSpeed,
		ySpeed=gameSpeed,
		timer=startPause
	}

	resetBall()

end

function love.update(dt)

	if love.keyboard.isDown("escape") then love.event.quit() end

	movePlayer()
	moveBot()
	moveBall()

	if player.score > 9999 or bot.score > 9999 then player.score, bot.score = 0, 0 end

end

function love.draw()
	
	love.graphics.clear()
	
	drawNet()
	
	love.graphics.print(player.score, window.width/4-font:getWidth(player.score)/2+20, 20)
	
	love.graphics.print(bot.score, window.width/4*3-font:getWidth(bot.score)/2+20, 20)
	
	love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
	
	if ball.timer < 0 then love.graphics.rectangle("fill", ball.x, ball.y, ball.size, ball.size) end
	
	love.graphics.rectangle("fill", bot.x, bot.y, bot.width, bot.height)

end
