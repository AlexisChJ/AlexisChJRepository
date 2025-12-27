package com.example.hwk3alexischj;

import android.content.Context;
import android.content.Intent;
import android.os.Parcelable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.TextView;

import androidx.recyclerview.widget.RecyclerView;
import java.util.ArrayList;

public class TopicAdapter extends RecyclerView.Adapter<TopicAdapter.ViewHolder> {

    private ArrayList<Topic> topicArrayList;
    private Context context;

    public TopicAdapter(ArrayList<Topic> topicArrayList, Context context) {
        this.topicArrayList = topicArrayList;
        this.context = context;
    }

    @Override
    public TopicAdapter.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.topic_item, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(TopicAdapter.ViewHolder holder, int position) {
        Topic item = topicArrayList.get(position);
        holder.topicTitle.setText(item.getTitle());
        holder.topicDescr.setText(item.getDescription());

        holder.seeMore.setOnClickListener(v -> {
            int pos = holder.getAdapterPosition();
            if (pos == RecyclerView.NO_POSITION) return;

            Intent intent = new Intent(v.getContext(), Activity2.class);
            intent.putExtra("topic_index", pos);
            v.getContext().startActivity(intent);
        });
    }

    @Override
    public int getItemCount() {
        return topicArrayList.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        private TextView topicTitle, topicDescr;
        private ImageButton seeMore;
        public ViewHolder(View itemView) {
            super(itemView);
            topicTitle = itemView.findViewById(R.id.idTopicTitle);
            topicDescr = itemView.findViewById(R.id.idTopicDescr);
            seeMore = itemView.findViewById(R.id.seeMore);
        }
    }
}
