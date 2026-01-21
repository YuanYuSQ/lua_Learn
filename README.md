# lua和love2d引擎

SNKRX的[前身教程](https://github.com/a327ex/boipushy#),教程包括lua,love2d

## 日志

##### 2026/1/12  
熟悉lua的面向编程,lua里没有内置的类,需要用表和函数实现,这里的oop是第三方的库[rxi/classic](https://github.com/rxi/classic)
用法

```lua
class = request "classic"
rect = class:expend() --创建类

function rect:new(posx,posy,x,y)--创建方法
self.posx = posx or 0
self.posy = posy or 0
self.x = x or 100
self.y = y or 100
end

function rect:draw()

end

function rect:fadein()

end
```
---
##### 2026/1/14  

练习 `hump.timer` 的 `after` 与 `tween`，写了`HpRect`类。

```lua
timer:tween(0.1 * self.speed, self, { rectside = { x = self.faderectside.x } }, 'in-linear', function()
                timer:tween(0.1 * self.speed, self, { bkrectside = { x = self.rectside.x } }, 'in-quad', function())
                end)
```
##### 用法先欠這

---
##### 2026/1/18
研究comfyUI,和HugginggFace,终端一直在报错`= =` 整天都在面對CMD和PSL

---
##### 2026/1/20
- 重构了`HPrect`

 ```lua
 ocal HpRect = class:extend()

function HpRect:new(rectsidemax, maxhp, minhp, pos, hpcolor, bkcolor, speed)
    self.maxhp = maxhp or 100
    self.minhp = minhp or 0
    self.currenthp = self.maxhp
    self.rectsidemax = rectsidemax or { x = 200, y = 35 } --初始血量矩形大小,便于计算血量比例
    --后续改用color类来表示颜色
    self.hpcolor = hpcolor or { 255 / 255, 89 / 255, 89 / 255 }
    self.bkcolor = bkcolor or { 226 / 255, 37 / 255, 50 / 255 }
    self.bkrectside = self.rectsidemax --背景矩形大小
    self.rectside = rectsidemax or { x = 200, y = 35 }
    self.pos = pos or { x = 100, y = 100 }
    self.speed = speed or 3                                          --血量动画速度
    self.faderectside = { x = self.rectside.x, y = self.rectside.y } --缓冲血量
end

--扣血实现,在main.lua中调用,例如：hpRect:hurt(10) 表示扣10点血
function HpRect:hurt(damage)
    if self.currenthp > self.minhp and self.rectside.x > 0 then
        self.currenthp = math.max(self.currenthp - damage, self.minhp)
        self.faderectside.x = (self.currenthp / self.maxhp) * self.rectsidemax.x
        -- 确保目标宽度不为负数
        self.faderectside.x = math.max(self.faderectside.x, 0)

        if self.faderectside.x > 0 then
            timer:tween(0.1 * self.speed, self, { rectside = { x = self.faderectside.x } }, 'in-linear', function()
                -- tween 完成后再次强制非负，防止多次快速调用产生负值
                self.rectside.x = math.max((self.rectside.x or 0), 0)
                timer:tween(0.1 * self.speed, self, { bkrectside = { x = self.rectside.x } }, 'in-quad', function()
                    self.bkrectside.x = math.max((self.bkrectside.x or 0), 0)
                end)
            end)
        else
            self.rectside.x = 0
            self.bkrectside.x = 0
        end
    end
end

function HpRect:draw(x, y)
    if x == nil and y == nil then
        love.graphics.setColor(self.bkcolor)
        love.graphics.rectangle("fill", love.graphics.getWidth() / 2 - self.pos.x,
            love.graphics.getHeight() / 2 - self.bkrectside.y / 2, self.bkrectside.x, self.bkrectside.y)                                                                   --HP背景
        love.graphics.setColor(self.hpcolor)
        love.graphics.rectangle("fill", love.graphics.getWidth() / 2 - self.pos.x,
            love.graphics.getHeight() / 2 - self.rectside.y / 2, self.rectside.x, self.rectside.y)                                                                         --血量
    else
        love.graphics.setColor(self.bkcolor)
        love.graphics.rectangle("fill", x, y, self.bkrectside.x, self.bkrectside.y) --HP背景
        love.graphics.setColor(self.hpcolor)
        love.graphics.rectangle("fill", x, y, self.rectside.x, self.rectside.y)     --血量
    end
end
 ```


- 新增了`input`[类](https://github.com/a327ex/boipushy#),可以直接在`update()`执行交互逻辑了

 `input`使用前需要先绑定按键,按键可以绑定动作

 ```lua
    input:bind("q", "hurt")
 ```

这里将`q`键绑定到`hurt`这个动作,使用时可以直接如上图所示判断`hurt`是否被触发,更易理解,后续将增加自定义绑键

```lua
function love.update(dt)
    timer:update(dt)
    if input:pressed("hurt") and hpRect.rectside.x > 0 then
        hpRect:hurt(10)
    end
    if input:pressed("click") then
        playHpRect:hurt(10)
    end
end
```



- 在 `objects.lua` 中：给 `HpRect:hurt` 增加宽度非负约束（clamp），并在 tween 回调处再次强制 non-negative，防止在短时间内多次调用导致 `rectside.x < 0`。
- 更新 TODO 列表以追踪分析与验证步骤。

运行 Love2D 项目并按 `q` 或点击快速触发 `hurt()`，观察 `rectside.x` 为负。

---
