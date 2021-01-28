

import 'dart:async';

import 'package:library_base/mvvm/view_state.dart';
import 'package:library_base/mvvm/view_state_model.dart';
import 'package:library_base/net/apis.dart';
import 'package:library_base/net/dio_util.dart';
import 'package:library_base/net/model/tree_node.dart';
import 'package:library_base/utils/object_util.dart';

class TreemapModel extends ViewStateModel {

  List<TreeNode> treeNodeList = [];
  List<Map<String, Object>> treeData = [];

  TreemapModel() : super(viewState: ViewState.first);

  Future getTreemap() {
    Map<String, dynamic> params = {
    };

    return DioUtil.getInstance().requestNetwork(Apis.URL_GET_TREEMAP, 'get', params: params,
        cancelToken: cancelToken,
        onSuccess: (data) {

          List<TreeNode> newsList = TreeNode.fromJsonList(data) ?? [];
          treeNodeList.clear();
          treeNodeList.addAll(newsList);

          treeData.clear();
          for (TreeNode treeNode in treeNodeList) {
            Map<String, Object> nodeMap = {
              'name': treeNode.zh_name,
              'value': [treeNode.market_val, treeNode.change_percent, treeNode.color_index]
            };
            treeData.add(nodeMap);
          }

          if (ObjectUtil.isEmptyList(treeNodeList)) {
            setEmpty();
          } else {
            setSuccess();
          }
        },
        onError: (errno, msg) {
          setError(errno, message: msg);
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
