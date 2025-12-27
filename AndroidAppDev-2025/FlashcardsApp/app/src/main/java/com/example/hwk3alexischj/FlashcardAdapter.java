package com.example.hwk3alexischj;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import androidx.recyclerview.widget.RecyclerView;
import java.util.List;

public class FlashcardAdapter extends RecyclerView.Adapter<FlashcardAdapter.VH> {

    private final List<Flashcard> data;
    public FlashcardAdapter(List<Flashcard> data) {
        this.data = data;
    }

    @Override
    public VH onCreateViewHolder(ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.flashcard_item, parent, false);
        return new VH(v);
    }

    @Override
    public void onBindViewHolder(VH holder, int position) {
        Flashcard flashcard = data.get(position);
        holder.concept.setText(flashcard.getConcept());
        holder.answer.setText(flashcard.getAnswer());
    }

    @Override
    public int getItemCount() {
        return data.size();
    }

    static class VH extends RecyclerView.ViewHolder {
        private TextView concept, answer;
        public VH(View itemView) {
            super(itemView);
            concept = itemView.findViewById(R.id.idFlashcardConcept);
            answer = itemView.findViewById(R.id.idFlashcardAnsw);
        }
    }
}
