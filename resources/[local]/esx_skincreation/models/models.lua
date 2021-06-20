Models = {}
RegisteredModelsByGender = {female = {}, male = {}}
RegisteredModels = {}

function registerModel(modelName, modelLabel, gender)
	RegisteredModelsByGender[gender][modelName] = modelLabel
	RegisteredModels[modelName] = modelLabel
end
