function class(super, auto_construct_super)
	local auto_construct_super = auto_construct_super or (auto_construct_super == nil)
	local class_type = {}
	local mt = {}
	if super then
		class_type.super = super
		mt.__index = super
		local super_mt = getmetatable(super)
		mt.__newindex = super_mt and super_mt.__newindex
	end
	mt.__call = function(...)
		local obj = {}
		do
			local create
			create = function(c, ...)
				if c.super and auto_construct_super then
					create(c.super, ...)
				end
				if rawget(c, "ctor") then
					c.ctor(obj, ...)
				end
			end
			create(class_type, ...)
		end
		setmetatable(obj, {__index = class_type, __newindex = getmetatable(class_type) and getmetatable(class_type).__newindex})
		return obj
	end
	setmetatable(class_type, mt)
	return class_type
end
