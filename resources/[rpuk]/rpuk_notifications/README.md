# Mythic Progress Bar
A simple action bar resource which allows actions to be visually displayed to the player and provides a callback function so actions can be peformed if the event was cancelled or not.

## How To Use:
To use, you just need to add a TriggerEvent into your client script where you're wanting the event to happen. Example TriggerEvent call;

```lua
    TriggerEvent("mythic_progbar:client:progress", {
        name = "unique_action_name",
        duration = 10000,
        label = "Action Label",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "missheistdockssetup1clipboard@idle_a",
            anim = "idle_a",
        },
        prop = {
            model = "prop_paper_bag_small",
        }
    }, function(status)
        if not status then
            -- Do Something If Event Wasn't Cancelled
        end
    end)
```

```lua
      TriggerEvent("mythic_progbar:client:progress", {
        name = "",
        duration = 20000,
        label = "",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "missheistdockssetup1clipboard@idle_a",
            anim = "idle_a",
        },
        prop = {
            model = "",
        }
      }, function(status)
        if not status then
        --- Do somthing if completed
            TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = '' })
        elseif status then
            TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = '' })
            -- Do Something If Event Wasn't Cancelled
      end)

```

Most of these flags are fairly self-explanatory, but theres's a few that have several options;


controlDisables - This allows you to disable a few sets of controls, these are broken down into 4 sets that I've found most often I was wanting to disable at some point;
* disableMovement | Standard Character Movement
* disableCarMovement | Vehicle Movement Keys
* disableMouse | Moving mouse thus intern camera around ped
* disableCombat | Weapon firing & Melee attacking


animation - This allows you to define an animation to play while the event occurs. This has several options that can be used and uses a cascading options to determine which to play. Highest priority is a Task, than it'll use AnimDict & Anim, if neither of those exist but the animation list exists in the options it'll default to a hardcoded task.
* task | Highest priority - if defined, this will be the only value used for animation
* animDict & anim & flags | Second highest priority, if task isn't defined it will try to use these values. Flags isn't required, and if it isn't provided will default to 1 (full body uncontrollable)
* empty animation { } | Final fallback, if the animation list is still provided but nothing set (Or no valid names set) it will default to playing the PROP_HUMAN_BUM_BIN task.


prop - This will spawn the given prop name onto the player peds hand
* model | This will be the model name used to spawn the prop onto the player ped.

# Mythic Notifications
A simple notification system inspired by NoPixel's

![Image of Notification](https://i.imgur.com/shT1XWc.png)

## Use
To display a notification simply make a call like below (Client-Side) :

```lua
exports['mythic_notify']:SendAlert('type', 'message')
```

### Notification Styles
* Inform - 'inform'
* Error - 'error'
* Success - 'success'

### Client-Side Functions (All Exported)
* SendAlert ( type, text, length, style ) | Displays Standard Alert For Provided Time. Length & Style are both optional, if no length is passed it defaults to 2500ms or 2.5s. If no style is passed it will use the style of the passed alert type
* SendUniqueAlert ( id, type, text, length, style ) | Displays Standard Alert For Provided Time. Requires a unique ID to be passed, if an alert already exists with that ID it will simply update the existing alert and refresh the timer for the passed time. Allows you to prevent a massive amount of alerts being spammed.
* PersistentAlert ( action, id, type, text, style ) | Displays an alert that will persist on the screen until function is called again with end action.

### Client Events (Trigger Notification From Server)
* mythic_notify:client:SendAlert OBJECT { type, text, duration } - If no duration is given, will default to 2500ms
* mythic_notify:client:PersistentAlert OBJECT { action, id, type, text } - Note: If using end action, type & text can be excluded)

### Persistent Notifications Actions -
* start - ( id, type, text, style ) - Additionally, you can call PersistentAlert with the start action and pass an already existing ID to update the notification on the screen.
* end - ( id )

> Note About ID: This is expected to be an entirely unique value that your resource is responsible for tracking. I’d suggest using something related to your resource name so there’s no chance of interferring with any other persistent notifications that may exist.

### Custom Style Format -
The custom style is a simple array in key, value format where the key is the CSS style attribute and the value is whatever you want to set that CSS attribute to.

#### Examples -
##### Client:
```LUA
exports['mythic_notify']:SendAlert('inform', 'Hype! Custom Styling!', 2500, { ['background-color'] = '#ffffff', ['color'] = '#000000' })
```

##### Server:
```LUA
TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Hype! Custom Styling!', length = 2500, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
```

> Note: When calling through the event, you can omit the length parameter and the alert will default to 2500 ms or ~2.5 seconds

##### Result:
![Custom Styling](https://i.imgur.com/FClWCqm.png)