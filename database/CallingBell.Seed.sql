SET XACT_ABORT ON;
GO

BEGIN TRY
BEGIN TRANSACTION;

DECLARE @Images TABLE
(
    ImageKey NVARCHAR(80) NOT NULL PRIMARY KEY,
    ImageUrl NVARCHAR(1000) NOT NULL
);

INSERT INTO @Images (ImageKey, ImageUrl)
VALUES
    (N'home-services', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201200%20800%22%3E%3Crect%20width%3D%221200%22%20height%3D%22800%22%20fill%3D%22%230f3d5e%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22400%22%20r%3D%22230%22%20fill%3D%22%2338bdf8%22%2F%3E%3Cpath%20d%3D%22M410%20540h380V360L600%20220%20410%20360z%22%20fill%3D%22%23e0f2fe%22%2F%3E%3Cpath%20d%3D%22M545%20540V420h110v120%22%20fill%3D%22%230f3d5e%22%2F%3E%3C%2Fsvg%3E'),
    (N'health-wellness', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201200%20800%22%3E%3Crect%20width%3D%221200%22%20height%3D%22800%22%20fill%3D%22%23065f46%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22400%22%20r%3D%22230%22%20fill%3D%22%2334d399%22%2F%3E%3Cpath%20d%3D%22M600%20570%20385%20370q-75-90%2040-160q100-60%20175%2050q75-110%20175-50q115%2070%2040%20160z%22%20fill%3D%22%23ecfdf5%22%2F%3E%3C%2Fsvg%3E'),
    (N'beauty-spa', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201200%20800%22%3E%3Crect%20width%3D%221200%22%20height%3D%22800%22%20fill%3D%22%239d174d%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22400%22%20r%3D%22230%22%20fill%3D%22%23f472b6%22%2F%3E%3Cpath%20d%3D%22M600%20190l55%20155l165%2055l-165%2055l-55%20165l-55-165l-165-55l165-55z%22%20fill%3D%22%23fdf2f8%22%2F%3E%3C%2Fsvg%3E'),
    (N'events-celebrations', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201200%20800%22%3E%3Crect%20width%3D%221200%22%20height%3D%22800%22%20fill%3D%22%237c2d12%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22400%22%20r%3D%22230%22%20fill%3D%22%23fb923c%22%2F%3E%3Cpath%20d%3D%22M385%20560l75-310l140%2075l140-75l75%20310z%22%20fill%3D%22%23fff7ed%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22425%22%20r%3D%2275%22%20fill%3D%22%23f97316%22%2F%3E%3C%2Fsvg%3E'),
    (N'repairs', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201200%20800%22%3E%3Crect%20width%3D%221200%22%20height%3D%22800%22%20fill%3D%22%23334155%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22400%22%20r%3D%22230%22%20fill%3D%22%2394a3b8%22%2F%3E%3Cpath%20d%3D%22M440%20560l95-95l-80-80q-35-75%2035-145q70-70%20145-35l-80%2080l80%2080l95-95q35%2070-35%20145l-80-80l-95%2095z%22%20fill%3D%22%23f8fafc%22%2F%3E%3C%2Fsvg%3E'),
    (N'daily-needs', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201200%20800%22%3E%3Crect%20width%3D%221200%22%20height%3D%22800%22%20fill%3D%22%233f6212%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22400%22%20r%3D%22230%22%20fill%3D%22%2384cc16%22%2F%3E%3Cpath%20d%3D%22M425%20335h350l-35%20240H460z%22%20fill%3D%22%23f7fee7%22%2F%3E%3Cpath%20d%3D%22M510%20335q0-105%2090-105t90%20105%22%20fill%3D%22none%22%20stroke%3D%22%23f7fee7%22%20stroke-width%3D%2235%22%2F%3E%3C%2Fsvg%3E'),
    (N'education', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201200%20800%22%3E%3Crect%20width%3D%221200%22%20height%3D%22800%22%20fill%3D%22%233733a3%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22400%22%20r%3D%22230%22%20fill%3D%22%23818cf8%22%2F%3E%3Cpath%20d%3D%22M360%20390l240-135l240%20135l-240%20135z%22%20fill%3D%22%23eef2ff%22%2F%3E%3Cpath%20d%3D%22M465%20450v105q135%2085%20270%200V450%22%20fill%3D%22%23c7d2fe%22%2F%3E%3C%2Fsvg%3E'),
    (N'professional-services', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201200%20800%22%3E%3Crect%20width%3D%221200%22%20height%3D%22800%22%20fill%3D%22%231e3a8a%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22400%22%20r%3D%22230%22%20fill%3D%22%2360a5fa%22%2F%3E%3Cpath%20d%3D%22M400%20345h400v235H400z%22%20fill%3D%22%23eff6ff%22%2F%3E%3Cpath%20d%3D%22M520%20345v-45q0-50%2080-50t80%2050v45%22%20fill%3D%22none%22%20stroke%3D%22%23eff6ff%22%20stroke-width%3D%2230%22%2F%3E%3C%2Fsvg%3E'),
    (N'food-dining', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201200%20800%22%3E%3Crect%20width%3D%221200%22%20height%3D%22800%22%20fill%3D%22%237c2d12%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22400%22%20r%3D%22230%22%20fill%3D%22%23f97316%22%2F%3E%3Cpath%20d%3D%22M430%20310h340v260H430z%22%20fill%3D%22%23fff7ed%22%2F%3E%3Cpath%20d%3D%22M500%20310q100-130%20200%200%22%20fill%3D%22none%22%20stroke%3D%22%23fff7ed%22%20stroke-width%3D%2230%22%2F%3E%3C%2Fsvg%3E'),
    (N'travel-transport', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201200%20800%22%3E%3Crect%20width%3D%221200%22%20height%3D%22800%22%20fill%3D%22%230c4a6e%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22400%22%20r%3D%22230%22%20fill%3D%22%2338bdf8%22%2F%3E%3Cpath%20d%3D%22M330%20440l270-90l270%2090l-270%2090z%22%20fill%3D%22%23e0f2fe%22%2F%3E%3Cpath%20d%3D%22M600%20350V230%22%20stroke%3D%22%23e0f2fe%22%20stroke-width%3D%2230%22%2F%3E%3C%2Fsvg%3E'),
    (N'automotive', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201200%20800%22%3E%3Crect%20width%3D%221200%22%20height%3D%22800%22%20fill%3D%22%233f3f46%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22400%22%20r%3D%22230%22%20fill%3D%22%23a1a1aa%22%2F%3E%3Cpath%20d%3D%22M350%20490l55-150h390l55%20150z%22%20fill%3D%22%23f4f4f5%22%2F%3E%3Ccircle%20cx%3D%22470%22%20cy%3D%22495%22%20r%3D%2250%22%20fill%3D%22%233f3f46%22%2F%3E%3Ccircle%20cx%3D%22730%22%20cy%3D%22495%22%20r%3D%2250%22%20fill%3D%22%233f3f46%22%2F%3E%3C%2Fsvg%3E'),
    (N'pet-services', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201200%20800%22%3E%3Crect%20width%3D%221200%22%20height%3D%22800%22%20fill%3D%22%23701a75%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22400%22%20r%3D%22230%22%20fill%3D%22%23e879f9%22%2F%3E%3Ccircle%20cx%3D%22500%22%20cy%3D%22330%22%20r%3D%2270%22%20fill%3D%22%23fdf4ff%22%2F%3E%3Ccircle%20cx%3D%22700%22%20cy%3D%22330%22%20r%3D%2270%22%20fill%3D%22%23fdf4ff%22%2F%3E%3Cpath%20d%3D%22M450%20480q150%20140%20300%200%22%20fill%3D%22none%22%20stroke%3D%22%23fdf4ff%22%20stroke-width%3D%2240%22%2F%3E%3C%2Fsvg%3E'),
    (N'fashion-lifestyle', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201200%20800%22%3E%3Crect%20width%3D%221200%22%20height%3D%22800%22%20fill%3D%22%239f1239%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22400%22%20r%3D%22230%22%20fill%3D%22%23fb7185%22%2F%3E%3Cpath%20d%3D%22M450%20560l75-230l75%2090l75-90l75%20230z%22%20fill%3D%22%23fff1f2%22%2F%3E%3C%2Fsvg%3E'),
    (N'doctors-healthcare', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201200%20800%22%3E%3Crect%20width%3D%221200%22%20height%3D%22800%22%20fill%3D%22%23065f46%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22400%22%20r%3D%22230%22%20fill%3D%22%2334d399%22%2F%3E%3Cpath%20d%3D%22M540%20250h120v120h120v120H660v120H540V490H420V370h120z%22%20fill%3D%22%23ecfdf5%22%2F%3E%3C%2Fsvg%3E'),
    (N'food-restaurants', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201200%20800%22%3E%3Crect%20width%3D%221200%22%20height%3D%22800%22%20fill%3D%22%237c2d12%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22400%22%20r%3D%22230%22%20fill%3D%22%23fb923c%22%2F%3E%3Cpath%20d%3D%22M410%20380h380v170H410z%22%20fill%3D%22%23fff7ed%22%2F%3E%3Cpath%20d%3D%22M470%20380q130-150%20260%200%22%20fill%3D%22none%22%20stroke%3D%22%23fff7ed%22%20stroke-width%3D%2230%22%2F%3E%3C%2Fsvg%3E'),
    (N'real-estate', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201200%20800%22%3E%3Crect%20width%3D%221200%22%20height%3D%22800%22%20fill%3D%22%231e3a8a%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22400%22%20r%3D%22230%22%20fill%3D%22%2360a5fa%22%2F%3E%3Cpath%20d%3D%22M380%20550h440V350L600%20200L380%20350z%22%20fill%3D%22%23eff6ff%22%2F%3E%3Cpath%20d%3D%22M550%20550V420h100v130%22%20fill%3D%22%231e3a8a%22%2F%3E%3C%2Fsvg%3E'),
    (N'finance-insurance', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201200%20800%22%3E%3Crect%20width%3D%221200%22%20height%3D%22800%22%20fill%3D%22%23145132%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22400%22%20r%3D%22230%22%20fill%3D%22%2322c55e%22%2F%3E%3Cpath%20d%3D%22M600%20220l190%2080v150q0%20140-190%20220q-190-80-190-220V300z%22%20fill%3D%22%23dcfce7%22%2F%3E%3Cpath%20d%3D%22M520%20420l55%2055l110-120%22%20fill%3D%22none%22%20stroke%3D%22%23145132%22%20stroke-width%3D%2230%22%2F%3E%3C%2Fsvg%3E'),
    (N'electronics-technology', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201200%20800%22%3E%3Crect%20width%3D%221200%22%20height%3D%22800%22%20fill%3D%22%23312e81%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22400%22%20r%3D%22230%22%20fill%3D%22%23818cf8%22%2F%3E%3Crect%20x%3D%22420%22%20y%3D%22240%22%20width%3D%22360%22%20height%3D%22320%22%20rx%3D%2225%22%20fill%3D%22%23eef2ff%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22515%22%20r%3D%2220%22%20fill%3D%22%23312e81%22%2F%3E%3C%2Fsvg%3E'),
    (N'sports-fitness', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201200%20800%22%3E%3Crect%20width%3D%221200%22%20height%3D%22800%22%20fill%3D%22%239a3412%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22400%22%20r%3D%22230%22%20fill%3D%22%23f97316%22%2F%3E%3Ccircle%20cx%3D%22500%22%20cy%3D%22320%22%20r%3D%2260%22%20fill%3D%22%23fff7ed%22%2F%3E%3Cpath%20d%3D%22M500%20390v130M500%20430l-100%2060m100-60l100-60m-100%20190l-90%2070m90-70l100%2070%22%20stroke%3D%22%23fff7ed%22%20stroke-width%3D%2235%22%2F%3E%3C%2Fsvg%3E'),
    (N'personal-care', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201200%20800%22%3E%3Crect%20width%3D%221200%22%20height%3D%22800%22%20fill%3D%22%239d174d%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22400%22%20r%3D%22230%22%20fill%3D%22%23f472b6%22%2F%3E%3Cpath%20d%3D%22M450%20550q150-280%20300%200%22%20fill%3D%22none%22%20stroke%3D%22%23fdf2f8%22%20stroke-width%3D%2245%22%2F%3E%3Ccircle%20cx%3D%22520%22%20cy%3D%22310%22%20r%3D%2255%22%20fill%3D%22%23fdf2f8%22%2F%3E%3Ccircle%20cx%3D%22680%22%20cy%3D%22310%22%20r%3D%2255%22%20fill%3D%22%23fdf2f8%22%2F%3E%3C%2Fsvg%3E'),
    (N'industrial-manufacturing', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201200%20800%22%3E%3Crect%20width%3D%221200%22%20height%3D%22800%22%20fill%3D%22%23334155%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22400%22%20r%3D%22230%22%20fill%3D%22%2394a3b8%22%2F%3E%3Cpath%20d%3D%22M390%20560V360h420v200z%22%20fill%3D%22%23f8fafc%22%2F%3E%3Cpath%20d%3D%22M470%20360v-90h260v90M480%20450h60m60 0h60m60 0h60%22%20fill%3D%22none%22%20stroke%3D%22%23334155%22%20stroke-width%3D%2230%22%2F%3E%3C%2Fsvg%3E'),
    (N'local-shopping', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201200%20800%22%3E%3Crect%20width%3D%221200%22%20height%3D%22800%22%20fill%3D%22%233f6212%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22400%22%20r%3D%22230%22%20fill%3D%22%2384cc16%22%2F%3E%3Cpath%20d%3D%22M410%20340h380l-35%20230H445z%22%20fill%3D%22%23f7fee7%22%2F%3E%3Cpath%20d%3D%22M510%20340q0-100%2090-100t90%20100%22%20fill%3D%22none%22%20stroke%3D%22%23f7fee7%22%20stroke-width%3D%2235%22%2F%3E%3C%2Fsvg%3E'),
    (N'media-creative', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201200%20800%22%3E%3Crect%20width%3D%221200%22%20height%3D%22800%22%20fill%3D%22%235b2140%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22400%22%20r%3D%22230%22%20fill%3D%22%23f472b6%22%2F%3E%3Cpath%20d%3D%22M420%20550l80-280l100%20110l100-110l80%20280z%22%20fill%3D%22%23fdf2f8%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22400%22%20r%3D%2255%22%20fill%3D%22%235b2140%22%2F%3E%3C%2Fsvg%3E'),
    (N'legal-services', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201200%20800%22%3E%3Crect%20width%3D%221200%22%20height%3D%22800%22%20fill%3D%22%231e3a8a%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22400%22%20r%3D%22230%22%20fill%3D%22%233b82f6%22%2F%3E%3Cpath%20d%3D%22M600%20240v300M430%20300h340M430%20300l-90%20150h180zM770%20300l-90%20150h180z%22%20fill%3D%22none%22%20stroke%3D%22%23eff6ff%22%20stroke-width%3D%2230%22%2F%3E%3C%2Fsvg%3E'),
    (N'logistics-delivery', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201200%20800%22%3E%3Crect%20width%3D%221200%22%20height%3D%22800%22%20fill%3D%22%230c4a6e%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22400%22%20r%3D%22230%22%20fill%3D%22%230ea5e9%22%2F%3E%3Cpath%20d%3D%22M350%20330h360v230H350zM710%20400h100l90%2090v70H710z%22%20fill%3D%22%23e0f2fe%22%2F%3E%3Ccircle%20cx%3D%22470%22%20cy%3D%22580%22%20r%3D%2240%22%20fill%3D%22%230c4a6e%22%2F%3E%3Ccircle%20cx%3D%22780%22%20cy%3D%22580%22%20r%3D%2240%22%20fill%3D%22%230c4a6e%22%2F%3E%3C%2Fsvg%3E'),
    (N'agriculture-farming', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201200%20800%22%3E%3Crect%20width%3D%221200%22%20height%3D%22800%22%20fill%3D%22%233f6212%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22400%22%20r%3D%22230%22%20fill%3D%22%2365a30d%22%2F%3E%3Cpath%20d%3D%22M600%20570V300M600%20380q-130-100-170-10q70%20100%20170%2010m0%2010q130-100%20170-10q-70%20100-170%2010%22%20fill%3D%22none%22%20stroke%3D%22%23ecfccb%22%20stroke-width%3D%2235%22%2F%3E%3C%2Fsvg%3E'),
    (N'trending-featured-services', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201200%20800%22%3E%3Crect%20width%3D%221200%22%20height%3D%22800%22%20fill%3D%22%237c2d12%22%2F%3E%3Ccircle%20cx%3D%22600%22%20cy%3D%22400%22%20r%3D%22230%22%20fill%3D%22%23f59e0b%22%2F%3E%3Cpath%20d%3D%22M600%20200l65%20135l150%2020l-110%20105l30%20150l-135-70l-135%2070l30-150l-110-105l150-20z%22%20fill%3D%22%23fffbeb%22%2F%3E%3C%2Fsvg%3E'),
    (N'banner-discover', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201600%20600%22%3E%3Crect%20width%3D%221600%22%20height%3D%22600%22%20fill%3D%22%230b2748%22%2F%3E%3Ccircle%20cx%3D%221260%22%20cy%3D%22120%22%20r%3D%22320%22%20fill%3D%22%232563eb%22%2F%3E%3Ccircle%20cx%3D%221390%22%20cy%3D%22530%22%20r%3D%22200%22%20fill%3D%22%2360a5fa%22%2F%3E%3Cpath%20d%3D%22M1030%20480h360V275l-180-130l-180%20130z%22%20fill%3D%22%23dbeafe%22%2F%3E%3C%2Fsvg%3E'),
    (N'banner-list-business', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201600%20600%22%3E%3Crect%20width%3D%221600%22%20height%3D%22600%22%20fill%3D%22%23173254%22%2F%3E%3Ccircle%20cx%3D%221300%22%20cy%3D%22110%22%20r%3D%22300%22%20fill%3D%22%230ea5e9%22%2F%3E%3Cpath%20d%3D%22M1040%20480h350V270h-350z%22%20fill%3D%22%23e0f2fe%22%2F%3E%3Cpath%20d%3D%22M1135%20270v-55q0-45%2080-45t80%2045v55%22%20fill%3D%22none%22%20stroke%3D%22%23e0f2fe%22%20stroke-width%3D%2230%22%2F%3E%3C%2Fsvg%3E'),
    (N'banner-celebration', N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201600%20600%22%3E%3Crect%20width%3D%221600%22%20height%3D%22600%22%20fill%3D%22%235b2140%22%2F%3E%3Ccircle%20cx%3D%221310%22%20cy%3D%22120%22%20r%3D%22310%22%20fill%3D%22%23f472b6%22%2F%3E%3Cpath%20d%3D%22M1050%20480l80-280l100%20120l100-120l80%20280z%22%20fill%3D%22%23fdf2f8%22%2F%3E%3Ccircle%20cx%3D%221230%22%20cy%3D%22375%22%20r%3D%2270%22%20fill%3D%22%23f9a8d4%22%2F%3E%3C%2Fsvg%3E');

DECLARE @Cities TABLE
(
    Name NVARCHAR(160) NOT NULL,
    Slug NVARCHAR(160) NOT NULL
);

INSERT INTO @Cities (Name, Slug)
VALUES
    (N'Bengaluru', N'bengaluru'),
    (N'Mysuru', N'mysuru'),
    (N'Hyderabad', N'hyderabad');

INSERT INTO dbo.Cities (Name, Slug, IsActive)
SELECT source.Name, source.Slug, 1
FROM @Cities source
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.Cities existing
    WHERE existing.Slug = source.Slug
);

DECLARE @Areas TABLE
(
    CitySlug NVARCHAR(160) NOT NULL,
    Name NVARCHAR(160) NOT NULL,
    Slug NVARCHAR(160) NOT NULL
);

INSERT INTO @Areas (CitySlug, Name, Slug)
VALUES
    (N'bengaluru', N'Indiranagar', N'indiranagar'),
    (N'bengaluru', N'Koramangala', N'koramangala'),
    (N'bengaluru', N'Whitefield', N'whitefield'),
    (N'mysuru', N'Gokulam', N'gokulam'),
    (N'mysuru', N'Vijayanagar', N'vijayanagar'),
    (N'hyderabad', N'Banjara Hills', N'banjara-hills'),
    (N'hyderabad', N'HITEC City', N'hitec-city');

INSERT INTO dbo.Areas (CityId, Name, Slug, IsActive)
SELECT city.CityId, source.Name, source.Slug, 1
FROM @Areas source
INNER JOIN dbo.Cities city ON city.Slug = source.CitySlug
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.Areas existing
    WHERE existing.CityId = city.CityId
      AND existing.Slug = source.Slug
);

DECLARE @Categories TABLE
(
    Name NVARCHAR(160) NOT NULL,
    Slug NVARCHAR(160) NOT NULL,
    Description NVARCHAR(1000) NOT NULL,
    ImageKey NVARCHAR(80) NOT NULL,
    Icon NVARCHAR(100) NOT NULL,
    AltText NVARCHAR(300) NOT NULL,
    DisplayOrder INT NOT NULL
);

INSERT INTO @Categories (Name, Slug, Description, ImageKey, Icon, AltText, DisplayOrder)
VALUES
    (N'Home Services', N'home-services', N'Cleaning, plumbing, electrical work, and other help for your home.', N'home-services', N'home', N'Home services', 10),
    (N'Health & Wellness', N'health-wellness', N'Clinics, fitness, and wellness services nearby.', N'health-wellness', N'heart-pulse', N'Health and wellness services', 20),
    (N'Beauty & Spa', N'beauty-spa', N'Salons, grooming, and relaxation services.', N'beauty-spa', N'sparkles', N'Beauty and spa services', 30),
    (N'Events & Celebrations', N'events-celebrations', N'Vendors to help plan memorable celebrations.', N'events-celebrations', N'party-popper', N'Event and celebration services', 40),
    (N'Repairs', N'repairs', N'Reliable technicians for electronics and appliances.', N'repairs', N'wrench', N'Repair services', 50),
    (N'Daily Needs', N'daily-needs', N'Everyday essentials from neighbourhood businesses.', N'daily-needs', N'shopping-bag', N'Daily needs', 60),
    (N'Education', N'education', N'Learning support for every age and stage.', N'education', N'graduation-cap', N'Education services', 70),
    (N'Professional Services', N'professional-services', N'Advisory and specialist business services.', N'professional-services', N'briefcase-business', N'Professional services', 80),
    (N'Food & Dining', N'food-dining', N'Restaurants, cafes, catering, and food delivery services.', N'food-dining', N'utensils', N'Food and dining services', 90),
    (N'Travel & Transport', N'travel-transport', N'Travel planning, cabs, rentals, and transport providers.', N'travel-transport', N'plane', N'Travel and transport services', 100),
    (N'Automotive', N'automotive', N'Car service, detailing, repairs, and vehicle support.', N'automotive', N'car-front', N'Automotive services', 110),
    (N'Pets & Animals', N'pet-services', N'Pet care, grooming, boarding, and veterinary services.', N'pet-services', N'paw-print', N'Pet services', 120),
    (N'Fashion & Lifestyle', N'fashion-lifestyle', N'Fashion, tailoring, accessories, and lifestyle services.', N'fashion-lifestyle', N'shirt', N'Fashion and lifestyle services', 130),
    (N'Home Services', N'main-home-services', N'Cleaning, plumbing, electrical work, and home support.', N'home-services', N'home', N'Home services', 140),
    (N'Doctors & Healthcare', N'doctors-healthcare', N'Doctors, clinics, diagnostics, and healthcare providers.', N'doctors-healthcare', N'heart-pulse', N'Doctors and healthcare', 150),
    (N'Beauty & Wellness', N'main-beauty-wellness', N'Salons, spas, grooming, and wellness providers.', N'beauty-spa', N'sparkles', N'Beauty and wellness', 160),
    (N'Food & Restaurants', N'food-restaurants', N'Restaurants, cafes, catering, and food delivery.', N'food-restaurants', N'utensils', N'Food and restaurants', 170),
    (N'Daily Needs & Shopping', N'daily-needs-shopping', N'Groceries, essentials, and everyday shopping services.', N'daily-needs', N'shopping-bag', N'Daily needs and shopping', 180),
    (N'Automobiles', N'automobiles', N'Vehicle sales, servicing, detailing, and support.', N'automotive', N'car-front', N'Automobiles', 190),
    (N'Real Estate', N'real-estate', N'Property sales, rentals, brokers, and home services.', N'real-estate', N'building-2', N'Real estate', 200),
    (N'Weddings & Events', N'weddings-events', N'Venues, planners, decorators, catering, and celebrations.', N'events-celebrations', N'party-popper', N'Weddings and events', 210),
    (N'Education', N'main-education', N'Schools, tutors, coaching, and learning programs.', N'education', N'graduation-cap', N'Education', 220),
    (N'Business & Professional Services', N'business-professional-services', N'Consulting, accounting, agencies, and business support.', N'professional-services', N'briefcase-business', N'Business and professional services', 230),
    (N'Finance & Insurance', N'finance-insurance', N'Banks, loans, investments, tax, and insurance services.', N'finance-insurance', N'landmark', N'Finance and insurance', 240),
    (N'Travel & Transport', N'main-travel-transport', N'Travel planning, cabs, rentals, and transport providers.', N'travel-transport', N'plane', N'Travel and transport', 250),
    (N'Repair & Maintenance', N'repair-maintenance', N'Home, appliance, electronics, and equipment repairs.', N'repairs', N'wrench', N'Repair and maintenance', 260),
    (N'Electronics & Technology', N'electronics-technology', N'Electronics, computers, software, and technology services.', N'electronics-technology', N'smartphone', N'Electronics and technology', 270),
    (N'Fashion & Lifestyle', N'main-fashion-lifestyle', N'Fashion, tailoring, accessories, and lifestyle services.', N'fashion-lifestyle', N'shirt', N'Fashion and lifestyle', 280),
    (N'Pets & Animals', N'main-pets-animals', N'Pet care, grooming, boarding, and veterinary services.', N'pet-services', N'paw-print', N'Pets and animals', 290),
    (N'Sports & Fitness', N'sports-fitness', N'Gyms, trainers, sports clubs, and fitness programs.', N'sports-fitness', N'dumbbell', N'Sports and fitness', 300),
    (N'Personal Care', N'personal-care', N'Barbers, salons, grooming, and personal care providers.', N'personal-care', N'user-round', N'Personal care', 310),
    (N'Industrial & Manufacturing', N'industrial-manufacturing', N'Factories, machinery, production, and industrial suppliers.', N'industrial-manufacturing', N'factory', N'Industrial and manufacturing', 320),
    (N'Local Shopping', N'local-shopping', N'Local stores, markets, boutiques, and retailers.', N'local-shopping', N'shopping-cart', N'Local shopping', 330),
    (N'Media & Creative', N'media-creative', N'Photography, video, design, music, and creative studios.', N'media-creative', N'camera', N'Media and creative services', 340),
    (N'Legal Services', N'legal-services', N'Lawyers, legal consultants, documentation, and compliance.', N'legal-services', N'scale', N'Legal services', 350),
    (N'Logistics & Delivery', N'logistics-delivery', N'Courier, freight, moving, and last-mile delivery.', N'logistics-delivery', N'truck', N'Logistics and delivery', 360),
    (N'Agriculture & Farming', N'agriculture-farming', N'Farms, nurseries, agri supplies, and farming services.', N'agriculture-farming', N'leaf', N'Agriculture and farming', 370),
    (N'Trending & Featured Services', N'trending-featured-services', N'Popular, sponsored, and highly rated local services.', N'trending-featured-services', N'star', N'Trending and featured services', 380);

INSERT INTO dbo.Categories
    (Name, Slug, Description, ImageUrl, ThumbnailUrl, MobileImageUrl, Icon, AltText, DisplayOrder, IsActive)
SELECT source.Name, source.Slug, source.Description, image.ImageUrl, image.ImageUrl, image.ImageUrl,
       source.Icon, source.AltText, source.DisplayOrder, 1
FROM @Categories source
INNER JOIN @Images image ON image.ImageKey = source.ImageKey
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.Categories existing
    WHERE existing.Slug = source.Slug
);

UPDATE target
SET ImageUrl = image.ImageUrl,
    ThumbnailUrl = image.ImageUrl,
    MobileImageUrl = image.ImageUrl,
    UpdatedDate = SYSUTCDATETIME()
FROM dbo.Categories target
INNER JOIN @Categories source ON source.Slug = target.Slug
INNER JOIN @Images image ON image.ImageKey = source.ImageKey;

DECLARE @Businesses TABLE
(
    BusinessName NVARCHAR(160) NOT NULL,
    Slug NVARCHAR(160) NOT NULL,
    OwnerName NVARCHAR(120) NOT NULL,
    CategorySlug NVARCHAR(160) NOT NULL,
    Description NVARCHAR(4000) NOT NULL,
    Phone NVARCHAR(30) NOT NULL,
    WhatsApp NVARCHAR(30) NOT NULL,
    Email NVARCHAR(254) NOT NULL,
    Address NVARCHAR(500) NOT NULL,
    CitySlug NVARCHAR(160) NOT NULL,
    AreaSlug NVARCHAR(160) NOT NULL,
    Pincode NVARCHAR(12) NOT NULL,
    Latitude DECIMAL(9, 6) NOT NULL,
    Longitude DECIMAL(9, 6) NOT NULL,
    Rating DECIMAL(3, 2) NOT NULL,
    ReviewCount INT NOT NULL,
    IsVerified BIT NOT NULL,
    IsSponsored BIT NOT NULL
);

INSERT INTO @Businesses
    (BusinessName, Slug, OwnerName, CategorySlug, Description, Phone, WhatsApp, Email, Address, CitySlug, AreaSlug, Pincode, Latitude, Longitude, Rating, ReviewCount, IsVerified, IsSponsored)
VALUES
    (N'BrightNest Cleaning', N'brightnest-cleaning', N'Asha Rao', N'home-services', N'Home and office cleaning with flexible appointments.', N'+918000000101', N'+918000000101', N'hello@brightnest.example', N'12th Main Road, Indiranagar', N'bengaluru', N'indiranagar', N'560038', 12.978400, 77.640800, 4.70, 128, 1, 1),
    (N'FixRight Plumbing', N'fixright-plumbing', N'Ravi Kumar', N'home-services', N'Plumbing repairs, installations, and emergency callouts.', N'+918000000102', N'+918000000102', N'care@fixright.example', N'80 Feet Road, Koramangala', N'bengaluru', N'koramangala', N'560034', 12.935200, 77.624500, 4.60, 94, 1, 0),
    (N'CareWell Clinic', N'carewell-clinic', N'Dr. Meera Shah', N'health-wellness', N'Family consultations and preventive care appointments.', N'+918000000103', N'+918000000103', N'appointments@carewell.example', N'CMH Road, Indiranagar', N'bengaluru', N'indiranagar', N'560038', 12.977500, 77.638900, 4.80, 211, 1, 1),
    (N'Pulse Fitness Studio', N'pulse-fitness-studio', N'Arjun Nair', N'health-wellness', N'Group fitness, personal coaching, and strength training.', N'+918000000104', N'+918000000104', N'join@pulsefitness.example', N'ITPL Main Road, Whitefield', N'bengaluru', N'whitefield', N'560066', 12.969800, 77.750000, 4.50, 76, 1, 0),
    (N'Glow & Go Salon', N'glow-and-go-salon', N'Neha Kapoor', N'beauty-spa', N'Hair, skin, and beauty care for everyday confidence.', N'+918000000105', N'+918000000105', N'bookings@glowandgo.example', N'5th Block, Koramangala', N'bengaluru', N'koramangala', N'560095', 12.933300, 77.626100, 4.70, 163, 1, 1),
    (N'Serene Spa', N'serene-spa', N'Priya Menon', N'beauty-spa', N'Relaxing wellness treatments and therapeutic massage.', N'+918000000106', N'+918000000106', N'hello@serenespa.example', N'Road No. 12, Banjara Hills', N'hyderabad', N'banjara-hills', N'500034', 17.423900, 78.450600, 4.60, 109, 1, 0),
    (N'Petal & Pine Events', N'petal-and-pine-events', N'Kabir Singh', N'events-celebrations', N'Event styling, floral arrangements, and coordination.', N'+918000000107', N'+918000000107', N'hello@petalandpine.example', N'Saraswathipuram, Vijayanagar', N'mysuru', N'vijayanagar', N'570017', 12.307600, 76.611000, 4.90, 87, 1, 1),
    (N'Frame & Feast Catering', N'frame-and-feast-catering', N'Lakshmi Iyer', N'events-celebrations', N'Freshly prepared menus for intimate and large gatherings.', N'+918000000108', N'+918000000108', N'events@frameandfeast.example', N'Gokulam Main Road, Gokulam', N'mysuru', N'gokulam', N'570002', 12.326000, 76.619500, 4.70, 66, 1, 0),
    (N'QuickCare Electronics', N'quickcare-electronics', N'Vikram Reddy', N'repairs', N'Diagnostics and repairs for phones, laptops, and home electronics.', N'+918000000109', N'+918000000109', N'support@quickcare.example', N'Madhapur Main Road, HITEC City', N'hyderabad', N'hitec-city', N'500081', 17.448300, 78.391500, 4.50, 142, 1, 1),
    (N'Fresh Basket Grocers', N'fresh-basket-grocers', N'Sana Ali', N'daily-needs', N'Neighbourhood grocery delivery and fresh daily essentials.', N'+918000000110', N'+918000000110', N'orders@freshbasket.example', N'100 Feet Road, Indiranagar', N'bengaluru', N'indiranagar', N'560038', 12.981600, 77.640200, 4.40, 58, 1, 0),
    (N'FirstStep Learning', N'firststep-learning', N'Divya Prasad', N'education', N'After-school learning support and skills workshops.', N'+918000000111', N'+918000000111', N'learn@firststep.example', N'Whitefield Main Road, Whitefield', N'bengaluru', N'whitefield', N'560066', 12.971600, 77.746100, 4.80, 119, 1, 0),
    (N'LedgerLine Advisors', N'ledgerline-advisors', N'Farhan Khan', N'professional-services', N'Practical accounting, tax, and compliance advisory.', N'+918000000112', N'+918000000112', N'contact@ledgerline.example', N'Outer Ring Road, Koramangala', N'bengaluru', N'koramangala', N'560103', 12.929000, 77.627100, 4.60, 73, 1, 0);

INSERT INTO dbo.Businesses
    (BusinessName, Slug, OwnerName, CategoryId, Description, Phone, WhatsApp, Email, Website, Address,
     CityId, AreaId, Pincode, Latitude, Longitude, LogoUrl, CoverImageUrl, Rating, ReviewCount,
     IsVerified, IsSponsored, IsActive)
SELECT source.BusinessName, source.Slug, source.OwnerName, category.CategoryId, source.Description,
       source.Phone, source.WhatsApp, source.Email, NULL, source.Address, city.CityId, area.AreaId,
       source.Pincode, source.Latitude, source.Longitude, image.ImageUrl, image.ImageUrl, source.Rating,
       source.ReviewCount, source.IsVerified, source.IsSponsored, 1
FROM @Businesses source
INNER JOIN dbo.Categories category ON category.Slug = source.CategorySlug
INNER JOIN dbo.Cities city ON city.Slug = source.CitySlug
INNER JOIN dbo.Areas area ON area.CityId = city.CityId AND area.Slug = source.AreaSlug
INNER JOIN @Images image ON image.ImageKey = source.CategorySlug
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.Businesses existing
    WHERE existing.Slug = source.Slug
);

UPDATE target
SET LogoUrl = image.ImageUrl,
    CoverImageUrl = image.ImageUrl,
    UpdatedDate = SYSUTCDATETIME()
FROM dbo.Businesses target
INNER JOIN @Businesses source ON source.Slug = target.Slug
INNER JOIN @Images image ON image.ImageKey = source.CategorySlug;

INSERT INTO dbo.BusinessImages
    (BusinessId, ImageUrl, ThumbnailUrl, MobileImageUrl, AltText, ImageType, DisplayOrder, IsPrimary, IsActive)
SELECT business.BusinessId, image.ImageUrl, image.ImageUrl, image.ImageUrl,
       CONCAT(business.BusinessName, N' service preview'), N'cover', 10, 1, 1
FROM dbo.Businesses business
INNER JOIN @Businesses source ON source.Slug = business.Slug
INNER JOIN @Images image ON image.ImageKey = source.CategorySlug
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.BusinessImages existing
    WHERE existing.BusinessId = business.BusinessId
      AND existing.ImageType = N'cover'
      AND existing.IsPrimary = 1
);

UPDATE target
SET ImageUrl = image.ImageUrl,
    ThumbnailUrl = image.ImageUrl,
    MobileImageUrl = image.ImageUrl,
    UpdatedDate = SYSUTCDATETIME()
FROM dbo.BusinessImages target
INNER JOIN dbo.Businesses business ON business.BusinessId = target.BusinessId
INNER JOIN @Businesses source ON source.Slug = business.Slug
INNER JOIN @Images image ON image.ImageKey = source.CategorySlug
WHERE target.ImageType = N'cover'
  AND target.IsPrimary = 1;

DECLARE @Banners TABLE
(
    Title NVARCHAR(200) NOT NULL,
    Subtitle NVARCHAR(500) NOT NULL,
    ImageKey NVARCHAR(80) NOT NULL,
    AltText NVARCHAR(300) NOT NULL,
    TargetUrl NVARCHAR(1000) NOT NULL,
    DisplayOrder INT NOT NULL
);

INSERT INTO @Banners (Title, Subtitle, ImageKey, AltText, TargetUrl, DisplayOrder)
VALUES
    (N'Find trusted local services', N'Explore verified businesses in your neighbourhood.', N'banner-discover', N'Find trusted local services', N'/search', 10),
    (N'Grow your local business', N'Create your business profile and reach more customers.', N'banner-list-business', N'List your business with Calling Bell', N'/register-business', 20),
    (N'Plan your next celebration', N'Discover event specialists, catering, and more.', N'banner-celebration', N'Explore event services', N'/search?category=events-celebrations', 30);

INSERT INTO dbo.Banners
    (Title, Subtitle, ImageUrl, ThumbnailUrl, MobileImageUrl, AltText, TargetUrl, DisplayOrder, IsActive)
SELECT source.Title, source.Subtitle, image.ImageUrl, image.ImageUrl, image.ImageUrl,
       source.AltText, source.TargetUrl, source.DisplayOrder, 1
FROM @Banners source
INNER JOIN @Images image ON image.ImageKey = source.ImageKey
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.Banners existing
    WHERE existing.Title = source.Title
);

UPDATE target
SET ImageUrl = image.ImageUrl,
    ThumbnailUrl = image.ImageUrl,
    MobileImageUrl = image.ImageUrl,
    UpdatedDate = SYSUTCDATETIME()
FROM dbo.Banners target
INNER JOIN @Banners source ON source.Title = target.Title
INNER JOIN @Images image ON image.ImageKey = source.ImageKey;

DECLARE @HomeSections TABLE
(
    SectionType NVARCHAR(50) NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    Subtitle NVARCHAR(500) NULL,
    Theme NVARCHAR(50) NOT NULL,
    DisplayOrder INT NOT NULL,
    MaxItems INT NOT NULL
);

INSERT INTO @HomeSections (SectionType, Title, Subtitle, Theme, DisplayOrder, MaxItems)
VALUES
    (N'BANNER', N'Discover local services', N'Everything you need, all in one place.', N'hero', 10, 3),
    (N'CATEGORY_GRID', N'Explore categories', N'Find the right service for your needs.', N'default', 20, 8),
    (N'SPONSORED', N'Featured businesses', N'Popular verified businesses near you.', N'accent', 30, 4),
    (N'TRENDING', N'Popular this week', N'Businesses customers are discovering right now.', N'default', 40, 6),
    (N'WEDDING', N'Plan your celebration', N'Explore services for memorable occasions.', N'default', 50, 1);

INSERT INTO dbo.HomeSections
    (SectionType, Title, Subtitle, Theme, DisplayOrder, MaxItems, IsActive)
SELECT source.SectionType, source.Title, source.Subtitle, source.Theme, source.DisplayOrder, source.MaxItems, 1
FROM @HomeSections source
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.HomeSections existing
    WHERE existing.SectionType = source.SectionType
)
AND NOT EXISTS
(
    SELECT 1
    FROM dbo.HomeSections existing
    WHERE existing.DisplayOrder = source.DisplayOrder
);

IF EXISTS
(
    SELECT 1
    FROM sys.check_constraints
    WHERE name = N'CK_HomeSections_MaxItems'
      AND parent_object_id = OBJECT_ID(N'dbo.HomeSections')
)
BEGIN
    ALTER TABLE dbo.HomeSections DROP CONSTRAINT CK_HomeSections_MaxItems;
END;

ALTER TABLE dbo.HomeSections
ADD CONSTRAINT CK_HomeSections_MaxItems CHECK (MaxItems BETWEEN 1 AND 50);

UPDATE dbo.HomeSections
SET MaxItems = 50,
    UpdatedDate = SYSUTCDATETIME()
WHERE SectionType = N'CATEGORY_GRID';

DECLARE @HomeSectionItems TABLE
(
    SectionType NVARCHAR(50) NOT NULL,
    SourceType NVARCHAR(20) NOT NULL,
    SourceKey NVARCHAR(200) NOT NULL,
    DisplayOrder INT NOT NULL
);

INSERT INTO @HomeSectionItems (SectionType, SourceType, SourceKey, DisplayOrder)
VALUES
    (N'BANNER', N'BANNER', N'Find trusted local services', 10),
    (N'BANNER', N'BANNER', N'Grow your local business', 20),
    (N'BANNER', N'BANNER', N'Plan your next celebration', 30),
    (N'CATEGORY_GRID', N'CATEGORY', N'home-services', 10),
    (N'CATEGORY_GRID', N'CATEGORY', N'health-wellness', 20),
    (N'CATEGORY_GRID', N'CATEGORY', N'beauty-spa', 30),
    (N'CATEGORY_GRID', N'CATEGORY', N'events-celebrations', 40),
    (N'CATEGORY_GRID', N'CATEGORY', N'repairs', 50),
    (N'CATEGORY_GRID', N'CATEGORY', N'daily-needs', 60),
    (N'CATEGORY_GRID', N'CATEGORY', N'education', 70),
    (N'CATEGORY_GRID', N'CATEGORY', N'professional-services', 80),
    (N'CATEGORY_GRID', N'CATEGORY', N'food-dining', 90),
    (N'CATEGORY_GRID', N'CATEGORY', N'travel-transport', 100),
    (N'CATEGORY_GRID', N'CATEGORY', N'automotive', 110),
    (N'CATEGORY_GRID', N'CATEGORY', N'pet-services', 120),
    (N'CATEGORY_GRID', N'CATEGORY', N'fashion-lifestyle', 130),
    (N'CATEGORY_GRID', N'CATEGORY', N'main-home-services', 140),
    (N'CATEGORY_GRID', N'CATEGORY', N'doctors-healthcare', 150),
    (N'CATEGORY_GRID', N'CATEGORY', N'main-beauty-wellness', 160),
    (N'CATEGORY_GRID', N'CATEGORY', N'food-restaurants', 170),
    (N'CATEGORY_GRID', N'CATEGORY', N'daily-needs-shopping', 180),
    (N'CATEGORY_GRID', N'CATEGORY', N'automobiles', 190),
    (N'CATEGORY_GRID', N'CATEGORY', N'real-estate', 200),
    (N'CATEGORY_GRID', N'CATEGORY', N'weddings-events', 210),
    (N'CATEGORY_GRID', N'CATEGORY', N'main-education', 220),
    (N'CATEGORY_GRID', N'CATEGORY', N'business-professional-services', 230),
    (N'CATEGORY_GRID', N'CATEGORY', N'finance-insurance', 240),
    (N'CATEGORY_GRID', N'CATEGORY', N'main-travel-transport', 250),
    (N'CATEGORY_GRID', N'CATEGORY', N'repair-maintenance', 260),
    (N'CATEGORY_GRID', N'CATEGORY', N'electronics-technology', 270),
    (N'CATEGORY_GRID', N'CATEGORY', N'main-fashion-lifestyle', 280),
    (N'CATEGORY_GRID', N'CATEGORY', N'main-pets-animals', 290),
    (N'CATEGORY_GRID', N'CATEGORY', N'sports-fitness', 300),
    (N'CATEGORY_GRID', N'CATEGORY', N'personal-care', 310),
    (N'CATEGORY_GRID', N'CATEGORY', N'industrial-manufacturing', 320),
    (N'CATEGORY_GRID', N'CATEGORY', N'local-shopping', 330),
    (N'CATEGORY_GRID', N'CATEGORY', N'media-creative', 340),
    (N'CATEGORY_GRID', N'CATEGORY', N'legal-services', 350),
    (N'CATEGORY_GRID', N'CATEGORY', N'logistics-delivery', 360),
    (N'CATEGORY_GRID', N'CATEGORY', N'agriculture-farming', 370),
    (N'CATEGORY_GRID', N'CATEGORY', N'trending-featured-services', 380),
    (N'SPONSORED', N'BUSINESS', N'brightnest-cleaning', 10),
    (N'SPONSORED', N'BUSINESS', N'carewell-clinic', 20),
    (N'SPONSORED', N'BUSINESS', N'glow-and-go-salon', 30),
    (N'SPONSORED', N'BUSINESS', N'petal-and-pine-events', 40),
    (N'TRENDING', N'BUSINESS', N'fixright-plumbing', 10),
    (N'TRENDING', N'BUSINESS', N'pulse-fitness-studio', 20),
    (N'TRENDING', N'BUSINESS', N'serene-spa', 30),
    (N'TRENDING', N'BUSINESS', N'quickcare-electronics', 40),
    (N'TRENDING', N'BUSINESS', N'firststep-learning', 50),
    (N'TRENDING', N'BUSINESS', N'ledgerline-advisors', 60),
    (N'WEDDING', N'CATEGORY', N'events-celebrations', 10);

INSERT INTO dbo.HomeSectionItems
    (HomeSectionId, CategoryId, BusinessId, BannerId, DisplayOrder, IsActive)
SELECT section.HomeSectionId,
       CASE WHEN source.SourceType = N'CATEGORY' THEN category.CategoryId END,
       CASE WHEN source.SourceType = N'BUSINESS' THEN business.BusinessId END,
       CASE WHEN source.SourceType = N'BANNER' THEN banner.BannerId END,
       source.DisplayOrder, 1
FROM @HomeSectionItems source
INNER JOIN dbo.HomeSections section ON section.SectionType = source.SectionType
LEFT JOIN dbo.Categories category ON source.SourceType = N'CATEGORY' AND category.Slug = source.SourceKey
LEFT JOIN dbo.Businesses business ON source.SourceType = N'BUSINESS' AND business.Slug = source.SourceKey
LEFT JOIN dbo.Banners banner ON source.SourceType = N'BANNER' AND banner.Title = source.SourceKey
WHERE
    (
        (source.SourceType = N'CATEGORY' AND category.CategoryId IS NOT NULL)
        OR (source.SourceType = N'BUSINESS' AND business.BusinessId IS NOT NULL)
        OR (source.SourceType = N'BANNER' AND banner.BannerId IS NOT NULL)
    )
    AND NOT EXISTS
    (
        SELECT 1
        FROM dbo.HomeSectionItems existing
        WHERE existing.HomeSectionId = section.HomeSectionId
          AND existing.DisplayOrder = source.DisplayOrder
    );

COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;

SELECT N'Areas' AS SourceTable, COUNT_BIG(*) AS TotalRows FROM dbo.Areas
UNION ALL SELECT N'Banners', COUNT_BIG(*) FROM dbo.Banners
UNION ALL SELECT N'Businesses', COUNT_BIG(*) FROM dbo.Businesses
UNION ALL SELECT N'BusinessImages', COUNT_BIG(*) FROM dbo.BusinessImages
UNION ALL SELECT N'Categories', COUNT_BIG(*) FROM dbo.Categories
UNION ALL SELECT N'Cities', COUNT_BIG(*) FROM dbo.Cities
UNION ALL SELECT N'HomeSectionItems', COUNT_BIG(*) FROM dbo.HomeSectionItems
UNION ALL SELECT N'HomeSections', COUNT_BIG(*) FROM dbo.HomeSections
ORDER BY SourceTable;
GO
