class ProductValidator {

  String validateImages(List images) {
    if(images.isEmpty){
      return "Adicione no minimo uma imagem!";
    }

    return null;
  }

  String validateTitle(String text) {
    if(text.isEmpty){
      return "Preencha o titulo do texto!";
    }

    return null;
  }

  String validateDescription(String text) {
    if(text.isEmpty){
      return "Preencha a descrição do produto!";
    }

    return null;
  }

  String validatePrice(String text) {
    double price = double.tryParse(text);
    if(price == null){
      return "Preço não é um valor real!";
    }

    if(!text.contains(".") || text.split(".")[1].length != 2){
      return "Utilize duas casas decimais!";
    }

    return null;
  }

}