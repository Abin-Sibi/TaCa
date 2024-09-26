// controllers/foodController.js
const Menu = require('../models/menu');

exports.getMenu = async (req, res) => {
    try {
      const { resId } = req.params;
      const menu = await Menu.find({ resId });
      res.status(200).json(menu);
    } catch (error) {
      res.status(500).json({ message: 'Failed to fetch menu items', error });
    }
  };

exports.createMenu = async (req, res) => {
  try {
    console.log(req.body.resId)
    const menu = new Menu({ ...req.body,
        resId: req.body.resId,});
    await menu.save();
    res.status(201).json(menu);
  } catch (error) {
    res.status(500).json({ message: 'Failed to add food item', error });
  }
};


exports.editMenu = async (req, res) => {
    try {
      const { id } = req.params;
      
      const { name, description, image, price } = req.body;
  
      const updatedMenu = await Menu.findByIdAndUpdate(
        id,
        { name, description, image, price },
        { new: true }
      );
      
      if (!updatedMenu) {
        return res.status(404).json({ message: 'Food item not found' });
      }
      console.log('ideee')
      res.status(200).json(updatedMenu);
    } catch (error) {
      res.status(500).json({ message: 'Failed to update food item', error });
    }
  };

  exports.deleteMenu = async (req, res) => {
    try {
      const { id } = req.params;
      const deletedMenu = await Menu.findByIdAndDelete(id);
  
      if (!deletedMenu) {
        return res.status(404).json({ message: 'Food item not found' });
      }
  
      res.status(200).json({ message: 'Food item deleted successfully' });
    } catch (error) {
      res.status(500).json({ message: 'Failed to delete food item', error });
    }
  };