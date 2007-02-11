# File: roottest/python/regression/PyROOT_regressiontests.py
# Author: Wim Lavrijsen (LBNL, WLavrijsen@lbl.gov)
# Created: 01/02/07
# Last: 02/08/07

"""Regression tests, lacking a better place, for PyROOT package."""

import os, sys, unittest
import commands
from ROOT import *

__all__ = [
   'Regression1TwiceImportStarTestCase',
   'Regression2PyExceptionTestcase',
   'Regression3UserDefinedNewOperatorTestCase',
   'Regression4ThreadingTestCase'
]


### "from ROOT import *" done in import-*-ed module ==========================
from Amir import *

class Regression1TwiceImportStarTestCase( unittest.TestCase ):
   def test1FromROOTImportStarInModule( self ):
      """Test handling of twice 'from ROOT import*'"""

      x = TestTChain()        # TestTChain defined in Amir.py


### TPyException thrown from C++ code ========================================
class Regression2PyExceptionTestcase( unittest.TestCase ):
   def test1RaiseAndTrapPyException( self ):
      """Test thrown TPyException object processing"""

      gROOT.LoadMacro( "Scott.C+" )

    # test of not overloaded global function
      self.assertRaises( SyntaxError, ThrowPyException )
      try:
         ThrowPyException()
      except SyntaxError, e:
         self.assertEqual( str(e), "test error message" )

    # test of overloaded function
      self.assertRaises( SyntaxError, MyThrowingClass.ThrowPyException, 1 )
      try:
         MyThrowingClass.ThrowPyException( 1 )
      except SyntaxError, e:
         self.assertEqual( str(e), "overloaded int test error message" )


### By-value return for class that defines operator new ======================
class Regression3UserDefinedNewOperatorTestCase( unittest.TestCase ):
   def test1CreateTemporary( self ):
      """Test handling of a temporary for user defined operator new"""

      gROOT.LoadMacro( "MuonTileID.C+" )

      getID()
      getID()                 # used to crash


### Test the condition under which to (not) start the GUI thread =============
class Regression4ThreadingTestCase( unittest.TestCase ):

   hasThread = gROOT.IsBatch() and 5 or 6   # can't test if no display ...
   noThread  = 5
   
   def test1SpecialCasegROOT( self ):
      """Test the special role that gROOT plays vis-a-vis threading"""

      cmd = "python -c 'import sys, ROOT; ROOT.gROOT; %s "\
            "sys.exit( 5 + int(\"thread\" in ROOT.__dict__) )'"

      stat, out = commands.getstatusoutput( cmd % "" )
      self.assertEqual( os.WEXITSTATUS(stat), self.noThread )

      stat, out = commands.getstatusoutput( cmd % "ROOT.gROOT.SetBatch( 1 );" )
      self.assertEqual( os.WEXITSTATUS(stat), self.noThread )

      stat, out = commands.getstatusoutput( cmd % "ROOT.gROOT.SetBatch( 0 );" )
      self.assertEqual( os.WEXITSTATUS(stat), self.noThread )

      stat, out = commands.getstatusoutput(
         cmd % "ROOT.gROOT.ProcessLine( \"cout << 42 << endl;\" ); " )
      self.assertEqual( os.WEXITSTATUS(stat), self.hasThread )

      stat, out = commands.getstatusoutput( cmd % "ROOT.gDebug;" )
      self.assertEqual( os.WEXITSTATUS(stat), self.hasThread )

   def test2ImportStyles( self ):
      """Test different import styles vis-a-vis threading"""

      cmd = "python -c 'import sys; %s ;"\
            "import ROOT; sys.exit( 5 + int(\"thread\" in ROOT.__dict__) )'"

      stat, out = commands.getstatusoutput( cmd % "from ROOT import *" )
      self.assertEqual( os.WEXITSTATUS(stat), self.hasThread )

      stat, out = commands.getstatusoutput( cmd % "from ROOT import gROOT" )
      self.assertEqual( os.WEXITSTATUS(stat), self.noThread )

      stat, out = commands.getstatusoutput( cmd % "from ROOT import gDebug" )
      self.assertEqual( os.WEXITSTATUS(stat), self.hasThread )

   def test3SettingOfBatchMode( self ):
      """Test various ways of preventing GUI thread startup"""

      cmd = "python -c '%s import ROOT, sys; sys.exit( 5+int(\"thread\" in ROOT.__dict__ ) )'"

      stat, out = commands.getstatusoutput( (cmd % 'from ROOT import *;') + ' - -b' )
      self.assertEqual( os.WEXITSTATUS(stat), self.noThread )

      stat, out = commands.getstatusoutput(
         cmd % 'import ROOT; ROOT.PyConfig.StartGuiThread = 0;' )
      self.assertEqual( os.WEXITSTATUS(stat), self.noThread )

      stat, out = commands.getstatusoutput(
         cmd % 'from ROOT import PyConfig; PyConfig.StartGuiThread = 0; from ROOT import gDebug;' )
      self.assertEqual( os.WEXITSTATUS(stat), self.noThread )

      stat, out = commands.getstatusoutput(
         cmd % 'from ROOT import PyConfig; PyConfig.StartGuiThread = 1; from ROOT import gDebug;' )
      self.assertEqual( os.WEXITSTATUS(stat), self.hasThread )

      stat, out = commands.getstatusoutput(
         cmd % 'from ROOT import gROOT; gROOT.SetBatch( 1 ); from ROOT import *;' )
      self.assertEqual( os.WEXITSTATUS(stat), self.noThread )

      if not gROOT.IsBatch():               # can't test if no display ...
         stat, out = commands.getstatusoutput(
            cmd % 'from ROOT import gROOT; gROOT.SetBatch( 0 ); from ROOT import *;' )
         self.assertEqual( os.WEXITSTATUS(stat), self.hasThread )


## actual test run
if __name__ == '__main__':
   sys.path.append( os.path.join( os.getcwd(), os.pardir ) )
   from MyTextTestRunner import MyTextTestRunner

   loader = unittest.TestLoader()
   testSuite = loader.loadTestsFromModule( sys.modules[ __name__ ] )

   runner = MyTextTestRunner( verbosity = 2 )
   result = not runner.run( testSuite ).wasSuccessful()

   sys.exit( result )