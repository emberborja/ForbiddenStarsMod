function onLoad()
  bags = {"cfd108", "e588c2", "a7ae4b", "cb678c"}
end

function introSetup()
  self.UI.show("players")
end

function customSetup()
  setup(bags[1])
end

function twoPlayers()
  setup(bags[2])
end

function threePlayers()
  setup(bags[3])
end

function fourPlayers()
  setup(bags[4])
end

function setup(bagGUID)
  self.destruct()
  unpack(bagGUID)
  removeBags()
end

function removeBags()
  for i, v in ipairs(bags) do
    getObjectFromGUID(v).destruct()
  end
end

function unpack(bagGUID)
  local bag = getObjectFromGUID(bagGUID)
  local data = bag.getTable("data")

  for i,v in ipairs(data) do
    bag.takeObject({
      guid=v[1],
      position={v[2], v[3], v[4]},
      rotation={v[5], v[6], v[7]},
      smooth=false,
      callback_function=function(obj) obj.setLock(v[8]) end
    })
  end
end