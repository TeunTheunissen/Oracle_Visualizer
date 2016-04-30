//this class shows a jframe with the legenda text.
import javax.swing.BorderFactory;
import javax.swing.border.BevelBorder;
import java.awt.Font;

class Legenda extends javax.swing.JFrame {
  private JLabel jLabel_HTML;
  private JTextArea legendaTextArea;
  private final String cstrHtmlTxtFile = "LegendaVisualisatie.txt";
  private final static char CR  = (char) 0x0D;
  private final static char LF  = (char) 0x0A;   
  private final static String CRLF  = "" + CR + LF;   
  private final static int FRMWIDTH = 540;
  private final static int FRMHEIGHT = 714;
  private final static String FRMTITLE="Legenda";
    public Legenda() {
    super();
    initGUI();
  }
  
  private void initGUI() {
    try {
      this.setTitle(FRMTITLE);
      this.setSize(FRMWIDTH, FRMHEIGHT);
      //jLabel_HTML = new JLabel();
      legendaTextArea = new JTextArea();
      legendaTextArea.setEditable(false);
      legendaTextArea.setFont(new Font(Font.MONOSPACED, Font.PLAIN, 12));
      getContentPane().add(legendaTextArea);
      legendaTextArea.setText(getLegendText());
      legendaTextArea.setBounds(0, 0, this.getWidth(), this.getHeight());
      legendaTextArea.setBorder(BorderFactory.createEtchedBorder(BevelBorder.LOWERED));
      pack();
    } catch (Exception e) {
        //add your error handling code here
      e.printStackTrace();
    }
  } //initGUI
  
  private String getLegendText(){
    String txt="";
    String lines[] = loadStrings(cstrHtmlTxtFile);

    for (int i = 0 ; i < lines.length; i++) {
      txt = txt + lines[i]+CRLF ;
    }
  return txt; 
  }
  
};