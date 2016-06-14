--
-- Copyright (c) 2015 Assured Information Security, Inc. <pattersonc@ainfosec.com>
-- Copyright (c) 2014 Citrix Systems, Inc.
-- 
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--

{-# LANGUAGE PatternGuards #-}

-- description: set syncvm to proper kernel path
-- date: 06/14/2016

module Migrations.M_28 (migration) where

import UpgradeEngine
import Data.List (foldl')

migration = Migration {
              sourceVersion = 28
            , targetVersion = 29
            , actions = act
            }

act :: IO ()
act = updateSyncvm

updateSyncvm = xformVmJSON xform where
  xform tree = case jsGet "/type" tree of
    Just s | jsUnboxString s == "syncvm" -> modify tree
    _ -> tree
    where
      modify = jsSet "/config/kernel-extract" (jsBoxString "\/boot\/bzImage)
