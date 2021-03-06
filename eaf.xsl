<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- actually, this is the inverse of zoom - the higher the number, the more -->
  <!-- compressed the time axis will be -->
  <xsl:variable name="zoom" select="8"/>

  <xsl:template match="/ANNOTATION_DOCUMENT">
    <html>
      <head>
        <title><xsl:value-of select="./@DATE"/></title>
        <link rel="stylesheet" type="text/css" href="css/eaf.css"/>
        <script src="//code.jquery.com/jquery-1.11.2.min.js"></script>
        <script src="js/eaf.js"></script>
      </head>
      <body>

        <audio id="wav" preload="none" controls="true">
          <source src="{./HEADER/MEDIA_DESCRIPTOR/@RELATIVE_MEDIA_URL}" type="audio/wav"/>
          <p>Your browser does not support the &lt;audio/&gt; tag.</p>
        </audio>

        <xsl:apply-templates select="TIER">
          <xsl:sort select="./@TIER_ID"/>
        </xsl:apply-templates>

      </body>
    </html>
  </xsl:template>

  <xsl:template match="TIER">
    <xsl:variable name="ling_type_ref" select="./@LINGUISTIC_TYPE_REF"/>
    <xsl:variable name="time_alignable"
                  select="//LINGUISTIC_TYPE[@LINGUISTIC_TYPE_ID =
                  $ling_type_ref]/@TIME_ALIGNABLE"/>

    <xsl:if test="$time_alignable = 'true'">
      <div class="tier" id="{translate(./@TIER_ID, ' ', '')}">
        <span class="label">
          <xsl:value-of select="./@TIER_ID"/>
        </span>
        <xsl:apply-templates select="./ANNOTATION/ALIGNABLE_ANNOTATION"/>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="ALIGNABLE_ANNOTATION">
    <xsl:variable name="start_ref" select="./@TIME_SLOT_REF1"/>
    <xsl:variable name="id" select="./@ANNOTATION_ID"/>
    <xsl:variable name="end_ref" select="./@TIME_SLOT_REF2"/>
    <xsl:variable name="start" select="//TIME_SLOT[@TIME_SLOT_ID =
                                       $start_ref]/@TIME_VALUE"/>
    <xsl:variable name="start_z" select="$start div $zoom"/>
    <xsl:variable name="length_z" select="(//TIME_SLOT[@TIME_SLOT_ID =
                                          $end_ref]/@TIME_VALUE div $zoom) - $start_z"/>

    <div class="annotation" style="left: {round($start_z)}px;
                                   width: {round($length_z)}px;"
         id="{$id}" start="{$start}">
      <p>
        <xsl:value-of select="./ANNOTATION_VALUE"/>
      </p>
      <p>
        <xsl:value-of select="//REF_ANNOTATION[@ANNOTATION_REF =
                              $id]/ANNOTATION_VALUE"/>
      </p>
    </div>
  </xsl:template>

</xsl:stylesheet>
