import javax.swing.JMenuItem;
import javax.swing.JPopupMenu;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.KeyStroke;
import java.awt.event.KeyEvent;
import java.awt.event.InputEvent;
import javax.swing.JCheckBoxMenuItem;
import javax.swing.JMenu;

class PopUpMenu extends JPopupMenu{

private Oracle_Visualizer owner;

public PopUpMenu(Oracle_Visualizer pOwner){
   
  owner = pOwner;
   ActionListener menuListener = new ActionListener() {
      public void actionPerformed(ActionEvent event) {
        //System.out.println("Popup menu item ["
        //    + event.getActionCommand() + "] was pressed.");
       JMenuItem menuclicked = (JMenuItem) event.getSource(); 
       procesmenuItem(menuclicked.getAccelerator());
      }
    };
 
   
    JMenu mnStandardFilters = new JMenu("Standard filters");
    add(mnStandardFilters);
    
    JMenuItem mntmProcedures = new JMenuItem("Procedures");
    mntmProcedures.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_0, InputEvent.CTRL_MASK));
    mntmProcedures.addActionListener(menuListener);
    mnStandardFilters.add(mntmProcedures);
    
    JMenuItem mntmFunctions = new JMenuItem("Functions");
    mntmFunctions.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_1, InputEvent.CTRL_MASK));
    mntmFunctions.addActionListener(menuListener);
    mnStandardFilters.add(mntmFunctions);
    
    JMenuItem mntmProceduresFunctions = new JMenuItem("Procedures + functions");
    mntmProceduresFunctions.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_2, InputEvent.CTRL_MASK));
    mntmProceduresFunctions.addActionListener(menuListener);
    mnStandardFilters.add(mntmProceduresFunctions);
    
    JMenuItem mntmFunctionsTables = new JMenuItem("Functions + tables");
    mntmFunctionsTables.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_3, InputEvent.CTRL_MASK));
    mntmFunctionsTables.addActionListener(menuListener);
    mnStandardFilters.add(mntmFunctionsTables);
    
    JMenuItem mntmPackagesTables = new JMenuItem("Packages + tables");
    mntmPackagesTables.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_4, InputEvent.CTRL_MASK));
    mntmPackagesTables.addActionListener(menuListener);
    mnStandardFilters.add(mntmPackagesTables);
    
    JMenuItem mntmProcedureFunctions = new JMenuItem("Procedure + functions + tables");
    mntmProcedureFunctions.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_5, InputEvent.CTRL_MASK));
    mntmProcedureFunctions.addActionListener(menuListener);
    mnStandardFilters.add(mntmProcedureFunctions);
    
    JMenuItem mntmPackages = new JMenuItem("Packages");
    mntmPackages.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_6, InputEvent.CTRL_MASK));
    mntmPackages.addActionListener(menuListener);
    mnStandardFilters.add(mntmPackages);
    
    JMenuItem mntmProcedurefunctionstables = new JMenuItem("Procedure+functions+tables");
    mntmProcedurefunctionstables.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_7, InputEvent.CTRL_MASK));
    mntmProcedurefunctionstables.addActionListener(menuListener);
    mnStandardFilters.add(mntmProcedurefunctionstables);
    
    JMenuItem mntmPackagestables = new JMenuItem("Packages+tables");
    mntmPackagestables.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_8, InputEvent.CTRL_MASK));
    mntmPackagestables.addActionListener(menuListener);
    mnStandardFilters.add(mntmPackagestables);
    
    JMenuItem mntmTriggersTables = new JMenuItem("Triggers + tables");
    mntmTriggersTables.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_9, InputEvent.CTRL_MASK));
    mntmTriggersTables.addActionListener(menuListener);
    mnStandardFilters.add(mntmTriggersTables);
    
    JMenu mnObjecttypeFilters = new JMenu("Objecttype filters");
    add(mnObjecttypeFilters);
    
    JMenuItem mntmProcedures_1 = new JMenuItem("Procedures");
    mntmProcedures_1.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_F1, InputEvent.CTRL_MASK));
    mntmProcedures_1.addActionListener(menuListener);
    mnObjecttypeFilters.add(mntmProcedures_1);
    
    JMenuItem mntmFunctions_1 = new JMenuItem("Functions");
    mntmFunctions_1.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_F2, InputEvent.CTRL_MASK));
    mntmFunctions_1.addActionListener(menuListener);
    mnObjecttypeFilters.add(mntmFunctions_1);
    
    JMenuItem mntmPackages_1 = new JMenuItem("Packages");
    mntmPackages_1.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_F3, InputEvent.CTRL_MASK));
    mntmPackages_1.addActionListener(menuListener);
    mnObjecttypeFilters.add(mntmPackages_1);
    
    JMenuItem mntmTriggers = new JMenuItem("Triggers");
    mntmTriggers.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_F5, InputEvent.CTRL_MASK));
    mntmTriggers.addActionListener(menuListener);
    mnObjecttypeFilters.add(mntmTriggers);
    
    JMenuItem mntmTables = new JMenuItem("Tables");
    mntmTables.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_F6, InputEvent.CTRL_MASK));
    mntmTables.addActionListener(menuListener);
    mnObjecttypeFilters.add(mntmTables);
    
    JMenuItem mntmSequences = new JMenuItem("Sequences");
    mntmSequences.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_F7, InputEvent.CTRL_MASK));
    mntmSequences.addActionListener(menuListener);
    mnObjecttypeFilters.add(mntmSequences);
    
    JMenu mnSearchFilters = new JMenu("Search filters");
    add(mnSearchFilters);
    
    JMenuItem mntmProcedures_2 = new JMenuItem("Procedures");
    mntmProcedures_2.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_F1, InputEvent.ALT_MASK));
    mntmProcedures_2.addActionListener(menuListener);
    mnSearchFilters.add(mntmProcedures_2);
    
    JMenuItem mntmFunctions_2 = new JMenuItem("Functions");
    mntmFunctions_2.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_F2, InputEvent.ALT_MASK));
    mntmFunctions_2.addActionListener(menuListener);
    mnSearchFilters.add(mntmFunctions_2);
    
    JMenuItem mntmPackages_2 = new JMenuItem("Packages");
    mntmPackages_2.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_F3, InputEvent.ALT_MASK));
    mntmPackages_2.addActionListener(menuListener);
    mnSearchFilters.add(mntmPackages_2);
    
    JMenuItem mntmTriggers_1 = new JMenuItem("Triggers");
    mntmTriggers_1.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_F5, InputEvent.ALT_MASK));
    mntmTriggers_1.addActionListener(menuListener);
    mnSearchFilters.add(mntmTriggers_1);
    
    JMenuItem mntmTables_1 = new JMenuItem("Tables");
    mntmTables_1.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_F6, InputEvent.ALT_MASK));
    mntmTables_1.addActionListener(menuListener);
    mnSearchFilters.add(mntmTables_1);
    
    JMenuItem mntmSequences_1 = new JMenuItem("Sequences");
    mntmSequences_1.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_F7, InputEvent.ALT_MASK));
    mntmSequences_1.addActionListener(menuListener);
    mnSearchFilters.add(mntmSequences_1);
    
    JMenuItem mntmShowTheLegenda = new JMenuItem("Show the legenda");
    mntmShowTheLegenda.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_I, InputEvent.ALT_MASK));
    mntmShowTheLegenda.addActionListener(menuListener);
    add(mntmShowTheLegenda);
    
    JMenuItem mntmSaveImage = new JMenuItem("Save image");
    mntmSaveImage.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_S, InputEvent.ALT_MASK));
    mntmSaveImage.addActionListener(menuListener);
    add(mntmSaveImage);
    
    JMenuItem mntmOpenADatafile = new JMenuItem("Open a datafile");
    mntmOpenADatafile.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_F, InputEvent.ALT_MASK));
    mntmOpenADatafile.addActionListener(menuListener);
    add(mntmOpenADatafile);

    JMenuItem mntmundoSelection = new JMenuItem("Undo selection");
    mntmundoSelection.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_U, InputEvent.CTRL_MASK));
    mntmundoSelection.addActionListener(menuListener);
    add(mntmundoSelection);

    JCheckBoxMenuItem mntmFreeseTheScreen = new JCheckBoxMenuItem("Freese the screen");
    mntmFreeseTheScreen.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_F, InputEvent.CTRL_MASK));
    mntmFreeseTheScreen.addActionListener(menuListener);
    add(mntmFreeseTheScreen);
    
    JCheckBoxMenuItem mntmShowSelection = new JCheckBoxMenuItem("Show selection");
    mntmShowSelection.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_S, InputEvent.CTRL_MASK));
    mntmShowSelection.addActionListener(menuListener);
    add(mntmShowSelection);
    
    JCheckBoxMenuItem mntmHideObjectUnselected = new JCheckBoxMenuItem("Hide object unselected");
    mntmHideObjectUnselected.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_H, InputEvent.CTRL_MASK));
    mntmHideObjectUnselected.addActionListener(menuListener);
    add(mntmHideObjectUnselected);
    
    JCheckBoxMenuItem chckbxmntmShowTextballoons = new JCheckBoxMenuItem("Show textballoons");
    chckbxmntmShowTextballoons.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_B, InputEvent.CTRL_MASK));
    chckbxmntmShowTextballoons.addActionListener(menuListener);
    add(chckbxmntmShowTextballoons);
    
    JCheckBoxMenuItem chckbxmntmShowText = new JCheckBoxMenuItem("Show text");
    chckbxmntmShowText.setSelected(true);
    chckbxmntmShowText.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_T, InputEvent.CTRL_MASK));
    chckbxmntmShowText.addActionListener(menuListener);
    add(chckbxmntmShowText);

    JCheckBoxMenuItem chckbxmntmEncrypText = new JCheckBoxMenuItem("Encrypt text");
    chckbxmntmEncrypText.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_E, InputEvent.CTRL_MASK));
    chckbxmntmEncrypText.addActionListener(menuListener);
    add(chckbxmntmEncrypText);
    
    
    JCheckBoxMenuItem chckbxmntmLogarithmicScale = new JCheckBoxMenuItem("Logarithmic scale");
    chckbxmntmLogarithmicScale.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_G, InputEvent.CTRL_MASK));
    chckbxmntmLogarithmicScale.addActionListener(menuListener);
    add(chckbxmntmLogarithmicScale);
    
    JCheckBoxMenuItem chckbxmntmShowRelatedObjects = new JCheckBoxMenuItem("Show related objects");
    chckbxmntmShowRelatedObjects.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_R, InputEvent.CTRL_MASK));
    chckbxmntmShowRelatedObjects.addActionListener(menuListener);
    add(chckbxmntmShowRelatedObjects);
  
}

/**
* Proces the with the menu associated key accelerator
* get the  ALT en CTRL key. 
**/
void procesmenuItem(KeyStroke pkeystroke ){
  int modifiers=0,modifier=0;
  //get bitpresentation of the keys pressed
  modifiers = pkeystroke.getModifiers(); //<>//
  //check for alt and ctrl key 
  if (modifiers >= InputEvent.ALT_DOWN_MASK) modifier = ALT; // "alt" + menukey; //mask  = 512 modifier = 520
  else if (modifiers >= InputEvent.CTRL_DOWN_MASK) modifier = CONTROL; // = "ctrl" + menukey; //mask = 128 modifier =130
  //proces the menu in the main class  
  owner.procesmenuItem(modifier,pkeystroke.getKeyCode());
}


}