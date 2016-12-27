package com.comtop.cap.bm.metadata.pdm.util;

import java.util.HashMap;
import java.util.Map;

import com.comtop.cap.bm.metadata.database.dbobject.model.TableVO;
import com.comtop.cap.bm.metadata.database.dbobject.model.ViewVO;
import com.comtop.cap.bm.metadata.pdm.model.PdmPoint;
import com.comtop.cap.bm.metadata.pdm.model.PdmReferanceSymbolVO;
import com.comtop.cap.bm.metadata.pdm.model.PdmSymbolVO;
import com.comtop.cap.bm.metadata.pdm.model.PdmTableSymbolVO;
import com.comtop.cap.bm.metadata.pdm.model.PdmViewSymbolVO;

/**
 * Created by duqi on 2016/2/23.
 */
public class SymbolHelper {
    /** tableSymbolId , PdmTableSymbolVO */
    private Map<String, PdmSymbolVO> tableSymbolVOMap = new HashMap<String, PdmSymbolVO>();

    /** 记录每列累加高度 */
    private int[] tableSymbolCols = new int[4];

    /** 自引用 */
    private static SymbolHelper objSymbolHelper;

    /**
     * 默认构造函数
     */
    public SymbolHelper(){
        for (int i = 0; i < 4; i++) {
            tableSymbolCols[i] = SymbolConstants.TABLE_START_Y;
        }
    }

    /**
     * 获取新的实例
     * @return 新的实例
     */
    public static SymbolHelper revert(){
        objSymbolHelper = new SymbolHelper();
        return objSymbolHelper;
    }

    /**
     * 获取已有实例
     * @return 已有实例
     */
    public static SymbolHelper getInstance(){
        if(objSymbolHelper == null){
            objSymbolHelper = new SymbolHelper();
        }
        return objSymbolHelper;
    }

    /**
     * 获得PdmTableSymbolVO
     * @param tableVO 表VO
     * @return PdmTableSymbolVO
     */
    public PdmTableSymbolVO getTableSymbol(TableVO tableVO){
        int fillCol = getFillCol();
        int endY = getEndY();
        int startX = SymbolConstants.TABLE_START_X + (SymbolConstants.TABLE_DEFAULT_WIDTH + SymbolConstants.TABLE_PADDING) * fillCol;
        int endX = startX + SymbolConstants.TABLE_DEFAULT_WIDTH;
        int startY = endY - SymbolConstants.TABLE_TITLE_HEIGHT - tableVO.getColumns().size() * SymbolConstants.TABLE_COLUMN_HEIGHT;
        tableSymbolCols[fillCol] = startY - SymbolConstants.TABLE_PADDING;
        PdmTableSymbolVO objPdmTableSymbolVO = new PdmTableSymbolVO();
        objPdmTableSymbolVO.setStartX(startX);
        objPdmTableSymbolVO.setStartY(startY);
        objPdmTableSymbolVO.setEndX(endX);
        objPdmTableSymbolVO.setEndY(endY);
        objPdmTableSymbolVO.setRefTableId(tableVO.getId());
        tableSymbolVOMap.put(objPdmTableSymbolVO.getId(), objPdmTableSymbolVO);
        return objPdmTableSymbolVO;
    }

    /**
     * 获得PdmViewSymbolVO
     * @param viewVO 视图VO
     * @return PdmViewSymbolVO
     */
    public PdmViewSymbolVO getViewSymbol(ViewVO viewVO){
        int fillCol = getFillCol();
        int endY = getEndY();
        int startX = SymbolConstants.TABLE_START_X + (SymbolConstants.TABLE_DEFAULT_WIDTH + SymbolConstants.TABLE_PADDING) * fillCol;
        int endX = startX + SymbolConstants.TABLE_DEFAULT_WIDTH;
        int startY = endY - SymbolConstants.TABLE_TITLE_HEIGHT - (viewVO.getColumns().size() + viewVO.getTables().size()) * SymbolConstants.TABLE_COLUMN_HEIGHT;
        tableSymbolCols[fillCol] = startY - SymbolConstants.TABLE_PADDING;
        PdmViewSymbolVO objPdmViewSymbolVO = new PdmViewSymbolVO();
        objPdmViewSymbolVO.setStartX(startX);
        objPdmViewSymbolVO.setStartY(startY);
        objPdmViewSymbolVO.setEndX(endX);
        objPdmViewSymbolVO.setEndY(endY);
        objPdmViewSymbolVO.setRefViewId(viewVO.getId());
        return objPdmViewSymbolVO;
    }

    /**
     * 获得PdmViewSymbolVO
     * @param sourceTableSymbolId 子表
     * @param destinationTableSymbolId 父表
     * @param referenceId 引用ID
     * @return PdmViewSymbolVO
     */
    public PdmReferanceSymbolVO getReferenceSymbol(String sourceTableSymbolId, String destinationTableSymbolId, String referenceId){
        PdmReferanceSymbolVO objPdmReferanceSymbolVO = new PdmReferanceSymbolVO();
        objPdmReferanceSymbolVO.setSourceTableSymbolId(sourceTableSymbolId);
        objPdmReferanceSymbolVO.setDestinationTableSymbolId(destinationTableSymbolId);
        objPdmReferanceSymbolVO.setRefReferanceId(referenceId);
        PdmSymbolVO sourceSymbolVO = tableSymbolVOMap.get(sourceTableSymbolId);
        PdmSymbolVO destinationSymbolVO = tableSymbolVOMap.get(destinationTableSymbolId);
        if(sourceSymbolVO == null || destinationSymbolVO == null){
            return objPdmReferanceSymbolVO;
        }
        int sourceX = 0;
        int sourceY = 0;
        int destinationX = 0;
        int destinationY = 0;
        if(sourceSymbolVO.getStartX() == destinationSymbolVO.getStartX()){
            sourceX = sourceSymbolVO.getStartX() + SymbolConstants.TABLE_DEFAULT_WIDTH / 2;
            destinationX = destinationSymbolVO.getStartX() + SymbolConstants.TABLE_DEFAULT_WIDTH / 2;
            if(sourceSymbolVO.getStartY() > destinationSymbolVO.getStartY()){
                sourceY = sourceSymbolVO.getStartY();
                destinationY = destinationSymbolVO.getEndY();
            }else{
                sourceY = sourceSymbolVO.getEndY();
                destinationY = destinationSymbolVO.getStartY();
            }
        }else{
            sourceY = sourceSymbolVO.getStartY() + (sourceSymbolVO.getEndY() -sourceSymbolVO.getStartY()) / 2;
            destinationY = destinationSymbolVO.getStartY() + (destinationSymbolVO.getEndY() - destinationSymbolVO.getStartY()) / 2;
            if(sourceSymbolVO.getStartX() < destinationSymbolVO.getStartX()){
                sourceX = sourceSymbolVO.getStartX() + SymbolConstants.TABLE_DEFAULT_WIDTH;
                destinationX = destinationSymbolVO.getStartX();
            }else{
                sourceX = sourceSymbolVO.getStartX();
                destinationX = destinationSymbolVO.getStartX() + SymbolConstants.TABLE_DEFAULT_WIDTH;
            }
        }
        objPdmReferanceSymbolVO.setStartX(sourceX < destinationX ? sourceX : destinationX);
        objPdmReferanceSymbolVO.setStartY(sourceY < destinationY ? sourceY : destinationY);
        objPdmReferanceSymbolVO.setEndX(sourceX > destinationX ? sourceX : destinationX);
        objPdmReferanceSymbolVO.setEndY(sourceY > destinationY ? sourceY : destinationY);
        objPdmReferanceSymbolVO.getPdmPoints().add(new PdmPoint(sourceX, sourceY));
        objPdmReferanceSymbolVO.getPdmPoints().add(new PdmPoint(destinationX, destinationY));
        return objPdmReferanceSymbolVO;
    }

    /**
     * 获取表格填充第几列
     * @return 表格填充第几列
     */
    private int getFillCol(){
        int tmpY = tableSymbolCols[0];
        int col = 0;
        for (int i = 1; i < tableSymbolCols.length; i++) {
            if (tableSymbolCols[i] > tmpY){
                col = i;
                tmpY = tableSymbolCols[i];
            }
        }
        return col;
    }

    /**
     * 获取endY
     * @return endY
     */
    private int getEndY(){
        int tmpY = tableSymbolCols[0];
        for (int i = 1; i < tableSymbolCols.length; i++) {
            if (tableSymbolCols[i] > tmpY){
                tmpY = tableSymbolCols[i];
            }
        }
        return tmpY - SymbolConstants.TABLE_PADDING;
    }

}
