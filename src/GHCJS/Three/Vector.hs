{-# LANGUAGE JavaScriptFFI #-}
module GHCJS.Three.Vector (
    TVector(..), Vector(..), NormalVector(..),
    mkVector, toTVector
    ) where

import Data.Functor
import GHCJS.Types

import GHCJS.Three.Monad

data TVector = TVector {
    x :: Double,
    y :: Double,
    z :: Double
} deriving (Show, Eq)

newtype Vector a = Vector {
    getObject :: Object a
}

instance ThreeJSRef (Vector a) where
    toJSRef = toJSRef . getObject
    fromJSRef = Vector . fromJSRef

-- normal vector is a special type of vector
data CNormalVector a
type NormalVector a = Vector (CNormalVector a)

foreign import javascript unsafe "new window.THREE.Vector3($1, $2, $3)"
    thr_mkVector :: Double -> Double -> Double -> Three JSRef

foreign import javascript safe "($1).x"
    thr_vecX :: JSRef -> Double
foreign import javascript safe "($1).y"
    thr_vecY :: JSRef -> Double
foreign import javascript safe "($1).z"
    thr_vecZ :: JSRef -> Double

vecX :: Vector a -> Double
vecX = thr_vecX . toJSRef

vecY :: Vector a -> Double
vecY = thr_vecY . toJSRef

vecZ :: Vector a -> Double
vecZ = thr_vecZ . toJSRef

-- | create a new Three Vector3 object with TVector
mkVector :: TVector -> Three (Vector ())
mkVector v = fromJSRef <$> thr_mkVector (x v) (y v) (z v)

-- | convert Vector to TVector
toTVector :: Vector a -> TVector
toTVector v = TVector (vecX v) (vecY v) (vecZ v)