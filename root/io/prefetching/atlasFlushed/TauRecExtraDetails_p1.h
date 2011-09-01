//////////////////////////////////////////////////////////
//   This class has been generated by TFile::MakeProject
//     (Tue Jun 14 15:33:00 2011 by ROOT version 5.31/01)
//      from the StreamerInfo in file http://root.cern.ch/files/atlasFlushed.root
//////////////////////////////////////////////////////////


#ifndef TauRecExtraDetails_p1_h
#define TauRecExtraDetails_p1_h
class TauRecExtraDetails_p1;

#include "TPObjRef.h"

class TauRecExtraDetails_p1 {

public:
// Nested classes declaration.

public:
// Data Members.
   TPObjRef    m_analysisHelper;    //
   int         m_seedType;          //
   int         m_numEMCells;        //
   float       m_stripET;           //
   float       m_emCentralityFraction;    //
   float       m_etHadAtEMScale;          //
   float       m_etEMAtEMScale;           //
   float       m_sumCellE;                //
   float       m_sumEMCellE;              //
   float       m_sumPTTracks;             //

   TauRecExtraDetails_p1();
   TauRecExtraDetails_p1(const TauRecExtraDetails_p1 & );
   virtual ~TauRecExtraDetails_p1();

};
#endif