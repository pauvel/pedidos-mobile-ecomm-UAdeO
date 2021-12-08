// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_fullpdfview/flutter_fullpdfview.dart';
// import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pedidos_mobile/src/providers/client_provider.dart';

// class Ticket extends StatefulWidget {
//   @override
//   _TicketState createState() => _TicketState();
// }

// class _TicketState extends State<Ticket> {
//   @override
//   void initState() {
//     super.initState();
//   }
//   Future<String> generateExampleDocument(String cl, int or) async {
//     final response = await ClientProvider().getOrderDetails(cl, or);
//     final order = response.order;
//     final orderProducts = response.orderProducts;

//     final products = orderProducts.map((v){
//         return """
//         <tr class="item">
//             <td>
//                 ${v.nombre}
//                 </td>
//                 <td>${v.cantidad}</td>
//                 <td>
//                     \$${v.importe}
//                 </td>
//             </tr>
//         """;
//     });

//     var htmlContent = """
//     <!DOCTYPE html>
//     <html>
//       <head>
//         <style>
//         .invoice-box {
//             max-width: 800px;
//             margin: auto;
//             padding: 30px;
//             font-size: 16px;
//             font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif;
//             color: #555;
//         }

//         .invoice-box table {
//             width: 100%;
//             line-height: inherit;
//             text-align: left;
//         }

//         .invoice-box table td {
//             padding: 5px;
//             vertical-align: top;
//         }

//         .invoice-box table tr td:nth-child(2) {
//             text-align: center;
//         }

//         .invoice-box table tr.top table td {
//             padding-bottom: 20px;
//         }

//         .invoice-box table tr.top table td.title {
//             font-size: 45px;
//             line-height: 45px;
//             color: #333;
//         }

//         .invoice-box table tr.information table td {
//             padding-bottom: 40px;
//         }

//         .invoice-box table tr.heading td {
//             background: #eee;
//             border-bottom: 1px solid #ddd;
//             font-weight: bold;
//         }

//         .invoice-box table tr.details td {
//             padding-bottom: 20px;
//         }

//         .invoice-box table tr.item td{
//             border-bottom: 1px solid #eee;
//         }

//         .invoice-box table tr.item.last td {
//             border-bottom: none;
//         }

//         .invoice-box table tr.total td:nth-child(3) {
//             border-top: 2px solid #eee;
//             font-weight: bold;
//         }
//         </style>
//         </head>

//         <body>
//         <div class="invoice-box">
//             <table cellpadding="0" cellspacing="0">
//                 <tr class="top">
//                     <td colspan="2">
//                         <table>
//                             <tr>
//                                 <td class="title">
//                                     <img src="https://res.cloudinary.com/dlds4xwpk/image/upload/v1606442600/pedidos_mobile_data/logo_cvf1ok.png" style="width:100%; max-width:300px;">
//                                 </td>
//                             </tr>
//                         </table>
//                     </td>
//                 </tr>
                
//                 <tr>
//                     <td colspan="2">
//                         <table>
//                             <tr>
//                                 <td>
//                                     Nombre de la empresa<br>
//                                     Direccion<br>
//                                     Localidad & CP
//                                 </td>
//                                 <td style="text-align: right;">
//                                     Folio #: ${order.id}<br>
//                                     Fecha: ${order.fecha.day}/${order.fecha.month}/${order.fecha.year} - ${order.hora}<br>
//                                     ${order.cliente}<br>
//                                     ${order.telefono}
//                                 </td>
//                             </tr>
//                         </table>
//                     </td>

//                 </tr>
                
//                 <tr class="heading">
//                     <td>
//                         Metodo de pago
//                     </td>

//                 </tr>
                
//                 <tr class="details">
//                     <td>
//                         En efectivo
//                     </td>
//                 </tr>
                
//                 <tr class="heading">
//                     <td>
//                         Producto
//                     </td>
                    
//                     <td>
//                         Cantidad
//                     </td>

//                     <td>
//                         Importe
//                     </td>
//                 </tr>
//                 $products
//                 <tr class="total">
//                     <td></td>
//                     <td></td>
                    
//                     <td>
//                     Total: \$${order.importe}
//                     </td>
//                 </tr>
//             </table>
//         </div>
//       </body>
//     </html>
//     """;

//     Directory appDocDir = await getApplicationDocumentsDirectory();
//     var targetPath = appDocDir.path;
//     var targetFileName = 'ticket#_${order.id}';

//     var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
//         htmlContent, targetPath, targetFileName);
//     return generatedPdfFile.path;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Map args = ModalRoute.of(context).settings.arguments;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Comprobante'),
//       ),
//       body: FutureBuilder(
//         future: generateExampleDocument(args[0] , args[1]),
//         builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
//           if(!snapshot.hasData) return Center(child: LinearProgressIndicator());
//           return PDFView(filePath: snapshot.data);
//         },
//       ),
//     );
//   }
// }