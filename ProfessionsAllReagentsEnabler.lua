local qualityDialog = ProfessionsFrame.CraftingPage.SchematicForm.QualityDialog
local isQualityDialogShown = false

local init = qualityDialog.Init
qualityDialog.Init = function(...)
  isQualityDialogShown = true
  return init(...)
end

local onClickAccept = qualityDialog.AcceptButton:GetScript('OnClick')
qualityDialog.AcceptButton:SetScript('OnClick', function(...)
  isQualityDialogShown = false
  return onClickAccept(...)
end)

local onClickCancel = qualityDialog.CancelButton:GetScript('OnClick')
qualityDialog.CancelButton:SetScript('OnClick', function(...)
  isQualityDialogShown = false
  return onClickCancel(...)
end)

local onCloseCallback = qualityDialog.onCloseCallback
qualityDialog.onCloseCallback = function(...)
  isQualityDialogShown = false
  return onCloseCallback(...)
end

-- Called to retrieve a reference to flyout.
local flyout = OpenProfessionsItemFlyout(UIParent, UIParent)
CloseProfessionsItemFlyout()

local retrieveCraftingReagentCount = ItemUtil.GetCraftingReagentCount
ItemUtil.GetCraftingReagentCount = function(...)
  if flyout:IsShown() then
    local count = retrieveCraftingReagentCount(...)
    if count >= 1 then
      return count
    else
      return 1
    end
  elseif isQualityDialogShown then
    local count = retrieveCraftingReagentCount(...)
    local quantityRequired = qualityDialog:GetQuantityRequired()
    if count >= quantityRequired then
      return count
    else
      return quantityRequired
    end
  else
    return retrieveCraftingReagentCount(...)
  end
end
