-- Universal Counter Tokens      coded by: MrStump

--Saves the count value into a table (data_to_save) then encodes it into the Tabletop save
function onSave()
    local data_to_save = {saved_count = count}
    saved_data = JSON.encode(data_to_save)
    return saved_data
end

--Loads the saved data then creates the buttons
function onload(saved_data)
    generateButtonParamiters()
    --Checks if there is a saved data. If there is, it gets the saved value for 'count'
    if saved_data ~= '' then
        local loaded_data = JSON.decode(saved_data)
        count = loaded_data.saved_count
    else
        --If there wasn't saved data, the default value is set to 10.
        count = 10
    end

    --Generates the buttons after putting the count value onto the 'display' button
    b_display.label = tostring(count)
    if count >= 100 then
        b_display.font_size = 360
    else
        b_display.font_size = 500
    end
    updateName()
    self.createButton(b_display)
    self.createButton(b_plus)
    self.createButton(b_minus)
    self.createButton(b_plus5)
    self.createButton(b_minus5)
end

function setCount(newCount)
    count = newCount
    updateDisplay()
end

function getCount()
    return count
end

function logManualChange(old)
    print("Space Marines: materiel "..old.." -> "..count)
end
function updateName()
    self.setName("Space Marines: "..count.." materiel")
end

--Activates when + is hit. Adds 1 to 'count' then updates the display button.
function increase()
    --Prevents count from going above 14
    if count < 14 then
        old = count
        count = count + 1
        updateDisplay()
        logManualChange(old)
    end
end

--Activates when - is hit. Subtracts 1 from 'count' then updates the display button.
function decrease()
    --Prevents count from going below 0
    if count > 0 then
        old = count
        count = count - 1
        updateDisplay()
        logManualChange(old)
    end
end

--Activates when + is hit. Adds 5 to 'count' then updates the display button.
function increase5()
    if count < 14 then
        old = count
        if count < 9 then
            count = count + 5
        else
            count = 14
        end
        updateDisplay()
        logManualChange(old)
    end
end

--Activates when - is hit. Subtracts 5 from 'count' then updates the display button.
function decrease5()
    --Prevents count from going below 0
    if count > 0 then
        old = count
        if count > 5 then
            count = count - 5
        else
            count = 0
        end
        updateDisplay()
        logManualChange(old)
    end
end

function customSet()
    local description = self.getDescription()
    if description ~= '' and type(tonumber(description)) == 'number' then
        self.setDescription('')
        count = tonumber(description)
        updateDisplay()
    end
end

--function that updates the display. I trigger it whenever I change 'count'
function updateDisplay()
    --If statement to resize font size if it gets too long
    if count >= 100 then
        b_display.font_size = 360
    else
        b_display.font_size = 500
    end
    b_display.label = tostring(count)
    self.editButton(b_display)
    updateName()
end

--This is activated when onload runs. This sets all paramiters for our buttons.
--I do not have to put this all into a function, but I prefer to do it this way.
function generateButtonParamiters()
    b_display = {
        index = 0, click_function = 'customSet', function_owner = self, label = '',
        position = {0,0.1,0}, width = 600, height = 600, font_size = 500
    }
    b_plus = {
        click_function = 'increase', function_owner = self, label =  '+',
        position = {0.9,0.1,0.3}, width = 300, height = 300, font_size = 400
    }
    b_minus = {
        click_function = 'decrease', function_owner = self, label =  '-',
        position = {-0.9,0.1,0.3}, width = 300, height = 300, font_size = 400
    }
    b_plus5 = {
        click_function = 'increase5', function_owner = self, label =  '+5',
        position = {0.9,0.1,-0.29}, width = 230, height = 230, font_size = 150
    }
    b_minus5 = {
        click_function = 'decrease5', function_owner = self, label =  '-5',
        position = {-0.9,0.1,-0.29}, width = 230, height = 230, font_size = 150
    }
end