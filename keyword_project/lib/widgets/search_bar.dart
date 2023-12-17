import 'package:flutter/material.dart';

class PostSearchBar extends StatefulWidget {
  final Function(String)? onSubmitted;

  const PostSearchBar({
    super.key, this.onSubmitted
  });

  @override
  State<PostSearchBar> createState() => _PostSearchBarState();
}

class _PostSearchBarState extends State<PostSearchBar> {
  

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          leading: IconButton(
            icon: const Icon(Icons.search),
            onPressed: (){}
          ),
          trailing: <Widget>[
            IconButton(onPressed: (){}, icon: const Icon(Icons.tune)),
          ],
          onTap: () {},
          onChanged: (_) {},
          onSubmitted: widget.onSubmitted,
        );
      }, 
      suggestionsBuilder: (BuildContext context, SearchController controller) {       
        return <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
            child: Row(
              children: [ ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("除濕機"),
            onTap: () {
              setState(() {
                controller.closeView("除濕機");
              });
            },
          ),
        ];
      }
    );
  }
}
