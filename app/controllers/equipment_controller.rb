class EquipmentController < ApplicationController
  before_filter :login_required;

  # we need to represent categories and nodes within the same
  # structure, so arbitrarily pick some large constant to add
  # to node ID values
  TreeNodeIDOffset = 100000;

  def tree
    @title = "Equipment Tree";
  end

  # take a scripaculous-form tree and save the ordering and nesting
  # into the database.
  def treesave
    # tree is a nested array of IDs, either > TreeNodeIDOffset for nodes, or not in case of categories
    # looks like: tree[0][id]=2&tree[0][0][id]=23&tree[0][1][id]=7&tree[0][1][0][id]=100002&tree[0][1][1][id]=100003&tree[0][2][id]=8&tree[0][2][0][id]=100005&tree[0][2][1][id]=100009&tree[0][3][id]=100001&tree[1][id]=3&tree[1][0][id]=13&tree[1][1][id]=14&tree[2][id]=4&tree[3][id]=5&tree[3][0][id]=15&tree[3][0][0][id]=100006&tree[3][0][1][id]=100007&tree[3][0][2][id]=100008

    def recursave(node, nodeidx, parentid)
      # determine node type
      if(!node["id"])
        return;
      end

      nodeid = node["id"].to_i();

      if(nodeid > TreeNodeIDOffset)
        #Equipment
        model = Equipment.find(nodeid - TreeNodeIDOffset);
        if(model)
          model.position = nodeidx;
          model.parent_id = parentid;
          model.save();
        end

      else
        #EquipmentCategory
        model = EquipmentCategory.find(nodeid);
        if(model)
          model.position = nodeidx;
          model.parent_id = parentid;
          model.save();
        end

        node.keys.each do |k|
          if(k != "id")
            recursave(node[k], k, model.id);
          end
        end
      end
    end

    tree = params["tree"];

    # the top level is a little strange, since there's no "id" with the root group; we
    # just split it manually into the recursive save above
    tree.keys.each do |k|
      recursave(tree[k], k, EquipmentCategory::Root_Category);
    end
  end

  # creates a new group under a given group
  # (meant to be used through Jscript)
  def newgroup
    id = params['id'];
    if(!id || !EquipmentCategory.find(id))
      flash[:error] = "Please select a valid group id.";
      return;
    end

    group = EquipmentCategory.new();
    group.name = "New Group";
    group.parent = EquipmentCategory.find(id);
    group.position = 0;
    group.save();
  end

  # creates a new item under a given group
  # (meant to be used through Jscript)
  def newitem
    id = params['id'];
    if(!id || !EquipmentCategory.find(id))
      flash[:error] = "Please select a valid group id.";
      return;
    end

    item = Equipment.new();
    item.description = "New Equipment";
    item.parent = EquipmentCategory.find(id);
    item.position = 0;
    item.shortname = "New Shortname"
    item.save();
  end

  # deletes a group, merges children to parent
  # (meant to be used through Jscript)
  def delgroup
    id = params['id'];

    if(id && (id.to_i() != EquipmentCategory::Root_Category))
      # move all remaining items in the group to the parent group
      category = EquipmentCategory.find(id);

      category.equipment.each do |item|
        item.parent = category.parent;
        item.save();
      end
      EquipmentCategory.delete(params['id']);
    end
  end

  # deletes an item
  # (meant to be used through Jscript)
  def delitem
    Equipment.delete(params['id']);
  end

  def edititem
    @title = "Editing Item"

    @item = Equipment.find(params['id']);
    if(!@item)
      flash[:error] = "Please select a valid item.";
    end
    render :layout => false
  end

  def editgroup
    @title = "Editing Group"

    @category = EquipmentCategory.find(params['id']);
    if(!@category)
      flash[:error] = "Please select a valid category.";
    end
    render :layout => false
  end

  def saveitem
    @title = "Saved Item";

    record = Equipment.find(params['id']);
    if(!record)
      flash[:error] = "Please select a valid item.";
      render :layout => false
    else
      record.update_attributes(params['item']);
      record.save();
      render :layout => false
    end
  end

  def savegroup
    @title = "Saved Group";

    record = EquipmentCategory.find(params['id']);
    if(!record)
      flash[:error] = "Please select a valid category.";
      render :layout => false
    else
      record.update_attributes(params['category']);
      record.save();
      render :layout => false
    end
  end

  def usage
    @step_hours  = 4; # must be a factor of 24

    # Determine date period
    begin
      @startdate = Time.parse(params['startdate']);
    rescue
      flash[:error] = "Start date format not valid.";
      @startdate   = Time.local(Time.now().year(), Time.now().month(), Time.now().day(), 0, 0, 0);
    end

    begin
      @enddate = Time.parse(params['enddate']);
    rescue
      flash[:error] = "End date format not valid.";
      @enddate   = @startdate + 7 * 24 * 60 * 60; # two weeks later
    end
  end
end
